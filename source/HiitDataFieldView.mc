import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.System as Sys;

class HiitDataFieldView extends WatchUi.DataField {

    hidden var mValue as String;

    function initialize() {
        DataField.initialize();
        mValue = "Unknown";
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void {
        // var obscurityFlags = DataField.getObscurityFlags();

        
        View.setLayout(Rez.Layouts.MainLayout(dc));
        var labelView = View.findDrawableById("label") as Text;
        labelView.locY = labelView.locY - 30;
        var valueView = View.findDrawableById("value") as Text;
        valueView.locY = valueView.locY + 30;
    

        (View.findDrawableById("label") as Text).setText(Rez.Strings.label);
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {
        // See Activity.Info in the documentation for available information.
    }

    // function onWorkoutStarted() as Void {
    //     Sys.println("[HiitDataFieldView] onWorkoutStarted");
    // }

    // function onWorkoutStepComplete() as Void {
    //     var currentStepInfo = Activity.getCurrentWorkoutStep() as Activity.WorkoutStepInfo;
    //     if (currentStepInfo != null) {
    //         mValue = currentStepInfo.name;
    //     } else {
    //         mValue = "N/A";
    //     }
        
    //     Sys.println("[HiitDataFieldView::onWorkoutStepComplete]: " + mValue);
    // }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        // Set the background color
        // var bgColor = Graphics.COLOR_ORANGE;
        // (View.findDrawableById("Background") as Text).setColor(getBackgroundColor());

        // Set the foreground color and value
        var value = View.findDrawableById("value") as Text;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            value.setColor(Graphics.COLOR_WHITE);
        } else {
            value.setColor(Graphics.COLOR_BLACK);
        }
        value.setText(mValue);

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

}
