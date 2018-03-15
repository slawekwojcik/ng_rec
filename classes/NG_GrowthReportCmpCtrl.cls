public with sharing class NG_GrowthReportCmpCtrl {
    private static final String EMP_COUNT_QUERY_ALL = 'SELECT Count() FROM Contact';
    
	@AuraEnabled
    public static List<GrowthResult> getResults() {
        
        GrowthResult growth3old = getGrowthForPeriod(-3, -2, '-2 Month');
		GrowthResult growth2old = getGrowthForPeriod(-2, -1, '-1 Month');
        GrowthResult growth1old = getGrowthForPeriod(-1, 0, 'Actual');
        
        Double avGrowth3old = getAvGrowth(new List<GrowthResult>{growth3old, growth2old, growth1old});
        GrowthResult growth1new = getFutureGrowth(growth1old.empsOnEnd, avGrowth3old, '+1 Month');
        
        Double avGrowth2old = getAvGrowth(new List<GrowthResult>{growth1new, growth2old, growth1old});
        GrowthResult growth2new = getFutureGrowth(growth1new.empsOnEnd, avGrowth2old, '+2 Month');

        Double avGrowth1old = getAvGrowth(new List<GrowthResult>{growth2new, growth1new, growth1old});
        GrowthResult growth3new = getFutureGrowth(growth2new.empsOnEnd, avGrowth1old, '+3 Month');        
      
        return new List<GrowthResult>{growth1old, growth1new, growth2new, growth3new};
    }
    
    private static GrowthResult getFutureGrowth(Integer empsStart, Double growth, String name) {
        Integer empsEnd = (Math.pow(growth + 1, (Double)3) * empsStart).intValue();
        return new GrowthResult(empsStart, empsEnd, growth, name);
    }
    
    private static GrowthResult getGrowthForPeriod(Integer monthsBeforeStart, Integer monthsBeforeEnd, String name) {
        String dateStart = NG_Utils.getTodayDateWithMonthsAsString(monthsBeforeStart);
        String dateEnd = NG_Utils.getTodayDateWithMonthsAsString(monthsBeforeEnd);
        
        Integer empPeriodBegin = getEmpCountOnDate(dateStart);
        Integer empPeriodEnd = getEmpCountOnDate(dateEnd);

        Double ex = 1.0/3.0;
        Double growth = Math.pow((Double)empPeriodEnd / empPeriodBegin, ex) - 1;
        return new GrowthResult(empPeriodBegin, empPeriodEnd, growth, name);
    }
    
    private static Integer getEmpCountOnDate(String dt) {
        String query = EMP_COUNT_QUERY_ALL;
        query += ' WHERE NG_EmploymentStartDate__c < ' + dt;
        query += ' AND (NG_EmploymentEndDate__c = null OR NG_EmploymentEndDate__c <= ' + dt + ')';
        return Database.countQuery(query);
    }
    
    private static Double getAvGrowth(List<GrowthResult> results) {
        Double growthSum = 0.0;
        for (GrowthResult gr : results) {
            growthSum += gr.growth;
        }
        return growthSum / results.size();
    }
    
    public class GrowthResult {
        @AuraEnabled
        public Integer empsOnStart {get; set;}
        @AuraEnabled
        public Integer empsOnEnd {get; set;}
        @AuraEnabled
        public Double growth {get; set;}
        @AuraEnabled
        public String name {get; set;}
        
        public GrowthResult(Integer empsOnStart, Integer empsOnEnd, Double growth, String name) {
            this.empsOnStart = empsOnStart;
            this.empsOnEnd = empsOnEnd;
            this.growth = growth;
            this.name = name;
        }
    }
}