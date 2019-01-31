package culture;

/**
 * Manager of culture data
 */
class CultureManager {
	/**
	 * Instance of manager
	 */
	public static final instance = new CultureManager();

	/**
	 * Cultures dictionary
	 */
	var cultures = new Map<String, Null<CultureData>>();

	/**
	 * Private constructor
	 */
	function new() {
		cultures["ru-RU"] = {
			nameDaysShortest: ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"],
			nameMonths: []
		};

		cultures["en-GB"] = {
			nameDaysShortest: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
			nameMonths: [
				"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
			]
		};
	}

	/**
	 * Get culture data by code
	 */
	public function getCulture(code:String):CultureData {
		var res = cultures[code];
		if (res == null)
			return cultures["en-GB"];
		return res;
	}
}
