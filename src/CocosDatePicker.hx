import culture.CultureData;
import DateManager.DayInfo;
import culture.CultureManager;
import js.Browser.*;
import js.html.InputElement;
import js.html.Element;

// Refference:
// http://t1m0n.name/air-datepicker/docs/index-ru.html
// https://www.cssscript.com/demo/minimal-inline-calendar-date-picker-vanilla-javascript/

/**
 * Picker day info for display
 */
typedef PickerDayInfoImpl = {
	> DayInfo,

	/**
	 * Foreign month
	 */
	var foreign:Bool;
}

@:forward
abstract PickerDayInfo(PickerDayInfoImpl) {
	/**
	 * Constructor
	 */
	public function new(value:PickerDayInfoImpl) {
		this = value;
	}

	@:from public static function from(value:DayInfo) {
		return new PickerDayInfo({
			monthDay: value.monthDay,
			weekDay: value.weekDay,
			month: value.month,
			year: value.year,
			foreign: false
		});
	}
}

/**
 * DatePicker widget for coconut.ui
 */
@:less("cocos_date_picker.less")
class CocosDatePicker extends coconut.ui.View {
	/**
	 * Picker panel
	 */
	@:ref var picker:Element;

	/**
	 * Date input element
	 */
	@:ref var input:InputElement;

	/**
	 * Start date
	 */
	@:attribute public var startDate:Date = @byDefault Date.now();

	/**
	 * Culture for localization
	 */
	@:attribute public var culture:String = @byDefault "en-GB";

	/**
	 * Current date
	 */
	@:state var currentDate:Date = Date.now();

    /**
     * Selected day index
     */
    @:state var selectedDayIndex:Int = @byDefault 0;

    /**
     * Days in calendar
     */
    var pickDays:Array<PickerDayInfo>;

	/**
	 * Add svg to buttons
	 * TODO: remove and add SVG inline
	 */
	function addSvg() {
		var element = document.querySelector(".nav.left");
		element.innerHTML = AssetHelper.inlineText('./src/assets/chevron-left.svg');
		element = document.querySelector(".nav.right");
		element.innerHTML = AssetHelper.inlineText('./src/assets/chevron-right.svg');
	}

	/**
	 * On component mount
	 */
	function viewDidMount() {
		addSvg();
	}

	/**
	 * On component update
	 */
	function viewDidUpdate() {
		addSvg();
	}

	/**
	 * On input click handler
	 */
	function onclick(e:js.html.Event) {
		showPicker();
		registerBodyClick();
	}

	/**
	 * On click out of picker
	 */
	function onOuterClick(e:js.html.Event) {
		if (picker.current != e.target && input.current != e.target) {
			unregisterBodyClick();
			hidePicker();
		}
	}

	/**
	 * Register handlers for click in document
	 */
	function registerBodyClick() {
		// document.addEventListener("click", onOuterClick);
	}

	/**
	 * Unregister handlers for click
	 */
	function unregisterBodyClick() {
		// document.removeEventListener("click", onOuterClick);
	}

	/**
	 * Show picker
	 */
	function showPicker() {
		picker.current.style.display = "block";
		// TODO calculate real height
		var inputHeight = input.current.clientHeight + 3;
		picker.current.style.marginTop = '${inputHeight}px';
	}

	/**
	 * Hide picker
	 */
	function hidePicker() {
		picker.current.style.display = "none";
	}

	/**
	 * Handle day click
	 * @param day
	 */
	function onDayClick(day:PickerDayInfo, idx:Int) {
        selectedDayIndex = idx;
	}

	/**
	 * Handle left navigating button click
	 */
	function onLeftClick() {
		var year = currentDate.getFullYear();
		var month = currentDate.getMonth();

		currentDate = new Date(year, month - 1, 1, 0, 0, 0);
		trace(currentDate);
	}

	/**
	 * Handle title click of calendar
	 */
	function onTitleClick() {}

	/**
	 * Handle right navigating button click
	 */
	function onRightClick() {
		var year = currentDate.getFullYear();
		var month = currentDate.getMonth();

		currentDate = new Date(year, month + 1, 1, 0, 0, 0);
		trace(currentDate);
	}

	/**
	 * Return days for calendar
	 */
	function getDays(cult:CultureData):Array<PickerDayInfo> {
		var pickDays = new Array<PickerDayInfo>();
        var month = currentDate.getMonth();
		var year = currentDate.getFullYear();

		var days = DateManager.instance.getMonthDays(month, year);
		var firstDay:PickerDayInfo = days[0];
		if (firstDay.weekDay > 0) {
			var lastDate = new Date(year, month - 1, 1, 0, 0, 0);
			var lastMonth = lastDate.getMonth();
			var lastYear = lastDate.getFullYear();
			var lastDays = DateManager.instance.getMonthDays(lastMonth, lastYear);

			var idx = lastDays.length - firstDay.weekDay - 1;
			for (i in 1...firstDay.weekDay + 1) {
				var pickDay:PickerDayInfo = lastDays[idx + i];
				pickDay.foreign = true;
				pickDays.push(pickDay);
			}
		}

		for (day in days)
			pickDays.push(day);

		var lastDay:PickerDayInfo = days[days.length - 1];
		if (lastDay.weekDay < DateManager.MAX_WEEK_OF_DAY) {
			var len = DateManager.MAX_WEEK_OF_DAY - lastDay.weekDay;
			var nextDate = new Date(year, month + 1, 1, 0, 0, 0);
			var nextMonth = nextDate.getMonth();
			var nextYear = nextDate.getFullYear();
			var nextDays = DateManager.instance.getMonthDays(nextMonth, nextYear);
			for (i in 0...len) {
				var pickDay:PickerDayInfo = nextDays[i];
                pickDay.foreign = true;
				pickDays.push(pickDay);
			}
		}

		return pickDays;
	}

	/**
	 * Render view
	 */
	function render() {
		var cult = CultureManager.instance.getCulture(culture);
		var month = currentDate.getMonth();
		var year = currentDate.getFullYear();
		var monthName = cult.nameMonths[month];

		pickDays = getDays(cult);
		var weekdays = cult.nameDaysShortest;

		return hxx('
            <div class="date-picker">
                <input ref=${input} type="text" class="place" onclick=${onclick} />
                <div ref=${picker} class="picker">
                    <div class="header">
                        <div class="nav left" onclick=${onLeftClick}></div>
                        <div class="title" onclick=${onTitleClick}>${monthName} ${year}</div>
                        <div class="nav right" onclick=${onRightClick}></div>
                    </div>
                    <div class="content">
                        <div class="week-days">
                            <for ${day in weekdays}>
                                <div class="day">${day.toUpperCase()}</div>
                            </for>
                        </div>
                        <div class="month-days">
                            <for ${i in 0...pickDays.length}>
                                <let day=${pickDays[i]}>
                                    <if ${day.foreign}>
                                        <div class="day foreign" onclick=${onDayClick(day, i)}>${day.monthDay}</div>
                                    <else>
                                        <if ${selectedDayIndex == i}>
                                            <div class="day selected">${day.monthDay}</div>
                                        <else>
                                            <div class="day" onclick=${onDayClick(day, i)}>${day.monthDay}</div>
                                        </if>
                                    </if>
                                </let>
                            </for>
                        </div>
                    </div>
                </div>
            </div>
        ');

	}
}
