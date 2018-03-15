public class NG_Utils {
    
    //utility to insert some test data
    public static void createEmployees(Integer numberOfEmps, Integer yearNo, Integer monthNo) {
        List<Contact> empsToCreate = new List<Contact>();
        for (Integer i=0; i<numberOfEmps; i++) {
            Integer noOfDays;
            Date dt = Date.today();
            if (monthNo == dt.month() && yearNo == dt.year()) {
                noOfDays = dt.day();
            } else {
                noOfDays = Date.daysInMonth(yearNo, monthNo);  
            } 
            Integer dayNo = genRandomDayNoForMonth(noOfDays);
            
            Date employmentStart = Date.newInstance(yearNo, monthNo, dayNo);
            empsToCreate.add(new NG_Employee(employmentStart).ct);
        }
        insert empsToCreate;
    }
    
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    
    private static Integer genRandomDayNoForMonth(Integer noOfDays) {
        Decimal d = math.random() * noOfDays -1;
        return d.intValue() + 1;
    }
    
    public static String getTodayDateWithMonthsAsString(Integer monthsToAdd) {
        Date dt = Date.today();
        return String.valueOf(dt.addMonths(monthsToAdd));
    }
}