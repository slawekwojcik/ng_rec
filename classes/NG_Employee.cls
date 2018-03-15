public class NG_Employee {
    public Contact ct {get; set;}
    
    public NG_Employee(Contact contact) {
        this.ct = contact;
    }
    
    public NG_Employee(Date employmentStart) {
        this.ct = new Contact();
		ct.LastName = NG_Utils.generateRandomString(10);
		ct.NG_EmploymentStartDate__c = employmentStart;
    }
    
    public Contact fireEmp(Integer daysAgo) {
        Date employmentEnd = Date.today();
		if (ct.NG_EmploymentStartDate__c >= employmentEnd) {
            employmentEnd = ct.NG_EmploymentStartDate__c;
        } else {
            employmentEnd = employmentEnd.addDays(-daysAgo);
        }
        ct.NG_EmploymentEndDate__c = employmentEnd;
        return ct;
    }
    
    public Contact fireEmp() {
        ct.NG_EmploymentEndDate__c = Date.today();
        return ct;
    }
    
    
}