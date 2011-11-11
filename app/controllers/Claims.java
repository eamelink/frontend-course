package controllers;

import java.util.Date;
import flexjson.JSONDeserializer;
import flexjson.transformer.DateTransformer;
import play.Logger;
import play.db.jpa.JPA;
import play.mvc.Controller;
import utils.Serializers;
import models.Claim;
import models.Line;

public class Claims extends Controller {
    
    /**
     * Return a JSON list of all claims
     */
    public static void list() {
        renderJSON(Serializers.ClaimSerializer.serialize(Claim.findAll()));
    }
    
    /**
     * Return a JSON representation of a single claim
     */
    public static void get(long id) {
        Claim claim = Claim.findById(id);
        notFoundIfNull(id);
        renderJSON(Serializers.ClaimSerializer.serialize(claim));
    }
    
    /**
     * Add a new claim to the database 
     */
    public static void add(String body) {
        Claim claim = Serializers.ClaimDeserializer.deserialize(body, Claim.class);
        claim.id = null;
        for(Line line : claim.lines) {
            line.claim = claim;
        }
        claim.save();
        renderJSON(Serializers.ClaimSerializer.serialize(claim));
    }
    
    /**
     * Update the properties of an existing claim
     * 
     * To make it simple, this method just deletes all the old lines,
     * and creates new lines
     */
    public static void update(long id, String body) {
        Line.delete("claim_id = ?", id);
        Claim claim = Claim.findById(id);
        Claim newClaim = Serializers.ClaimDeserializer.deserialize(body, Claim.class);
        for(Line line : newClaim.lines) {
            line.claim = newClaim;
        }
        claim = JPA.em().merge(newClaim);
        claim.save();
        renderJSON(Serializers.ClaimSerializer.serialize(claim));
    }
    
    /**
     * Delete a claim from the database
     */
    public static void delete(long id) {
        Claim claim = Claim.findById(id);
        claim.delete();
        ok();
    }
}