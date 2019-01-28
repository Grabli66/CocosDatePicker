class App extends coconut.ui.View {
    function render() {
        return hxx('
            <div id="input-container">
                <CocosDatePicker />
            </div>
        ');
    }
}