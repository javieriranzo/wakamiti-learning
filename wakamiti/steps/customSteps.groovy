package es.iti.wakamiti.custom

//import es.iti.kukumo.core.Kukumo
import es.iti.wakamiti.api.annotations.I18nResource
import es.iti.wakamiti.api.annotations.Step
import es.iti.wakamiti.api.annotations.SetUp
import es.iti.wakamiti.api.plan.DataTable
import es.iti.wakamiti.api.plan.Document
import es.iti.wakamiti.api.extensions.StepContributor
import es.iti.wakamiti.api.annotations.TearDown
import es.iti.wakamiti.api.WakamitiAPI
import es.iti.wakamiti.rest.RestStepContributor
import es.iti.wakamiti.database.DatabaseStepContributor

import java.nio.charset.StandardCharsets
import java.sql.Statement
import java.sql.ResultSet
import java.sql.SQLException
import java.util.concurrent.TimeUnit
import java.util.function.Consumer;

import io.restassured.path.json.JsonPath
import io.restassured.http.ContentType
import io.restassured.RestAssured
import io.restassured.http.ContentType
import io.restassured.path.json.JsonPath
import io.restassured.specification.RequestSpecification

import org.hamcrest.Matchers
import org.codehaus.plexus.util.Base64
import org.slf4j.Logger


@I18nResource("custom-steps")
class CustomSteps implements StepContributor {

    private WakamitiAPI wakamiti = WakamitiAPI.instance();

    def restStepContributor;
    def dbStepContributor;
    def parameters = [:]
    def regexFunction = /\{=(.+)\}/
    def loginUrl = "https://qa-identity.tibagroup.com/connect/token"
    //def loginUrl = "https://tiba-qa-identity.azurewebsites.net/connect/token"   
    //def loginUrl = "https://tiba-dora-qa-identity-api-us.azurewebsites.net/connect/token"

    private static String TOKEN_CACHE = null;

    @TearDown
    def clear() {
           wakamiti.contributors().stepContributors.clear()
     }

    @SetUp
    def getContributor() {
        restStepContributor = wakamiti.contributors().getContributor(RestStepContributor.class);
        dbStepContributor = wakamiti.contributors().getContributor(DatabaseStepContributor.class);
    }

    @Step(value = "custom.define.data.save", args = ["column:word", "table:word", "text"])
    def setStoredValue(String column, String table, String name, Document document) {
        def where = document.getContent()
        def select = "SELECT ${column} FROM ${table} WHERE ${where}"
        try (Statement statement = dbStepContributor.connection().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY)) {
            log.trace("[SQL] {}", select);
            ResultSet resultSet = statement.executeQuery(select);
            if (resultSet.last()) {
                int count = resultSet.getRow()
                if (count > 1) {
                    throw new RuntimeException("Too many results: " + count);
                }
                resultSet.beforeFirst();
            }
            if (resultSet.next()) {
                parameters[name] = Optional.of(resultSet.getString(1)).map(String::trim).get();
                log.debug("Value of {}.{} where {}:", table, column, where)
                log.debug(parameters[name])
            } else {
                throw new RuntimeException("No results found");
            }
        } catch (SQLException e) {
            log.error("[SQL] {}", select);
            throw new RuntimeException(e);
        }
    }

    @Step(value = "custom.define.query.parameters")
    def setQueryParameters(DataTable dataTable) {
        String[][] values = dataTable.getValues();
        for (int i = 1; i < dataTable.rows(); i++) {
            for (int j = 0; j < values[i].length; j++) {
                values[i][j] = transform(values[i][j])
            }
        }
        log.info("Transformed query parameters: {}", Arrays.deepToString(values))

        restStepContributor.setQueryParameters(new DataTable(values))
    }

    private String transform(String value) {
        if (value.matches(regexFunction)) {
            return Eval.me("parameters", parameters, (value =~ regexFunction)[ 0 ][ 1 ])
        }
        return value;
    }

    @Step(value = "custom.login", args = ["username:text","password:text"])
        def login(String username, String password) {
    		log.info("Autenticando con el usuario {}, contraseña {}", username, password)
            if (TOKEN_CACHE == null) {
                String token = RestAssured.given().log().all()
                        .contentType(ContentType.URLENC)
                        .auth().preemptive().basic("dora", "dE87s9Z5tT0EDvAjmgT3j7bBq4fdgQmb+1d/P4uRSPw=")
                        .formParam("grant_type", "password")
                        .formParam("username", username)
                        .formParam("password", password)
                        .formParam("scope", "openid profile dora_api dora_entities_api tiba-user-management purchase_and_quote_api tiba_md_api")
                        .post(loginUrl)
                        .then().log().all()
                        .statusCode(200)
                        .body("access_token", Matchers.notNullValue())
                        .extract().body().jsonPath().getString("access_token");

                TOKEN_CACHE = token;

            }

            restStepContributor.setHeader("Authorization","Bearer " + TOKEN_CACHE)
        }

    @Step(value = 'custom.simplyDelay', args = ["waitingSeconds:int"])
    def simplyDelay (Integer waitingSeconds) {
        
        TimeUnit.SECONDS.sleep(waitingSeconds);
    }
}
