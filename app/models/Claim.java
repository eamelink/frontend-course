package models;

import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.OneToMany;

import play.db.jpa.Model;

/**
 * An expense claim
 */
@Entity
public class Claim extends Model {
    /** The date this expense claim was filed **/
    public Date claimDate;
    
    /** The start of the period of expenses in this claim **/
    public Date startDate;
    
    /** The end of the period of expenses in this claim **/
    public Date endDate;
    
    /** The bank account number on which the expenses are to be reimbursed **/
    public String accountNumber;
    
    /** The name of the holder of the account on which the expenses are to be reimbursed **/
    public String accountName;
    
    @OneToMany(mappedBy="claim",cascade=CascadeType.ALL)
    public List<Line> lines;
}
