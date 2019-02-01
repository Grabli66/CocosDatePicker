/**
 * Information about day
 */
typedef DayInfo = {
	/**
	 * 1..31
	 */
	var monthDay:Int;

	/**
	 * 0..6
	 */
	var weekDay:Int;

	/**
	 * 0..12
	 */
	var month:Int;

	/**
	 * 0..infinite
	 */
	var year:Int;
}

/**
 * For getting dates, months, years
 */
class DateManager {
	/**
	 * Max week day number
	 */
	public static inline final MAX_WEEK_OF_DAY = 6; // 0 - Sunday

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
		var weekDayOfFirst = date.getDay();

		var res = new Array<DayInfo>();
		for (day in 1...dayCount + 1) {
			res.push({
				monthDay: day,
				weekDay: weekDayOfFirst,
				month: month,
				year: year
			});

			weekDayOfFirst += 1;
			if (weekDayOfFirst > MAX_WEEK_OF_DAY)
				weekDayOfFirst = 0;
		}
		return res;
	}
}
