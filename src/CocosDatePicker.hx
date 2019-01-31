import DateManager.DayInfo;
import culture.CultureManager;
import js.Browser.*;
import js.html.InputElement;
import js.html.Element;

// Refference: 
// http://t1m0n.name/air-datepicker/docs/index-ru.html
// https://www.cssscript.com/demo/minimal-inline-calendar-date-picker-vanilla-javascript/

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
     * On component mount
     */
    function viewDidMount() {
        var element = document.querySelector(".nav.left");
        element.innerHTML = AssetHelper.inlineText('./src/assets/chevron-left.svg');
        element = document.querySelector(".nav.right");
        element.innerHTML = AssetHelper.inlineText('./src/assets/chevron-right.svg');
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
        //document.addEventListener("click", onOuterClick);
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
    function onDayClick(day:DayInfo) {
        trace(day);
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
    function onTitleClick() {

    }

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
	 * Render view
	 */
	function render() {
        var cult = CultureManager.instance.getCulture(culture);
        var weekdays = cult.nameDaysShortest;
        var month = currentDate.getMonth();
        var year = currentDate.getFullYear();
        var monthName = cult.nameMonths[month];
        var days = DateManager.instance.getMonthDays(month, year);

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
                            <for ${day in days}>
                                <div class="day" onclick=${onDayClick(day)}>${day.day}</div>
                            </for>
                        </div>
                    </div>
                </div>
            </div>
        ');
	}
}