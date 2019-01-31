/**
 * Information about day
 */
typedef DayInfo = {
	var day:Int;
	var month:Int;
	var year:Int;
}

/**
 * For getting dates, months, years
 */
class DateManager {
	/**
	 * Instance of manager
	 */
	public static final instance = new DateManager();

	/**
	 * Constructor
	 */
	function new() {}

	/**
	 * Return month days
     * Month 0..11
	 */
	public function getMonthDays(month:Int, year:Int):Array<DayInfo> {
		var date = new Date(year, month, 1, 0, 0, 0);
		var dayCount = DateTools.getMonthDays(date);
		var res = [for (day in 1...dayCount + 1) {day: day, month: month, year: year}];
		return res;
	}
}
