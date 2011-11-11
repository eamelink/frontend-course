package models;

import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.ManyToOne;

import play.db.jpa.Model;

/**
 * Line in an expense claim
 */
@Entity
public class Line extends Model {
    /** The expense claim this line is a part of **/
    @ManyToOne
    public Claim claim;

    /** The date this expense was made **/
    public Date date;
    
    public String description;
    public BigDecimal amountExVat;
    public BigDecimal vat;
    public BigDecimal amountIncVat;
}
