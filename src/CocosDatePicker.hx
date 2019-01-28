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
     * On component mount
     */
    function viewDidMount() {        
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
        document.addEventListener("click", onOuterClick);
    }

    /**
     * Unregister handlers for click
     */
    function unregisterBodyClick() {
        document.removeEventListener("click", onOuterClick);
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
	 * Render view
	 */
	function render() {
		return hxx('
            <div class="date-picker">
                <input ref=${input} type="text" class="place" onclick=${onclick} />
                <div ref=${picker} class="picker">
                    <div class="header">
                        <div class="left">
                            
                        </div>
                        <div class="title">January 2019</div>
                        <div class="right"></div>
                    </div>
                </div>
            </div>
        ');
	}
}