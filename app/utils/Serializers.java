package utils;

import java.util.Date;

import models.Claim;
import models.Line;

import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import flexjson.transformer.DateTransformer;

public class Serializers {
    public static final JSONSerializer ClaimSerializer = new JSONSerializer()
        .include("id")
        .include("accountName")
        .include("accountNumber")
        .include("claimDate")
        .include("startDate")
        .include("endDate")
        .include("lines.date")
        .include("lines.description")
        .include("lines.vat")
        .include("lines.amountExVat")
        .include("lines.amountIncVat")
        .transform(new NullableDateTransformer("dd-MM-yyyy"), Date.class)
        .exclude("*");
    
    public static final JSONDeserializer<Claim> ClaimDeserializer = new JSONDeserializer<Claim>().
            use("lines.values", Line.class).
            use(Date.class, new NullableDateTransformer("dd-MM-yyyy"));
}
