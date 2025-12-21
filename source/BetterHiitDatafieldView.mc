import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.System as Sys;

class BetterHiitDatafieldView extends WatchUi.DataField {

    hidden var currStepName as String;
    hidden var currStepNote as String;

    function initialize() {
        DataField.initialize();
        
        currStepName = Rez.Strings.unknown as String;
        currStepNote = Rez.Strings.unknown as String;

        Sys.println("[BetterHiitDatafieldView] Initialized");
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void {
        // Sys.println("[BetterHiitDatafieldView] Layout config started...");
        // var obscurityFlags = DataField.getObscurityFlags();

        // Set positions
        View.setLayout(Rez.Layouts.MainLayout(dc));
        
        var labelField = View.findDrawableById("label") as Text;
        labelField.locY = labelField.locY - 90;
        
        var stepNameField = View.findDrawableById("step_name") as Text;
        stepNameField.locY = stepNameField.locY - 30;
    
        var stepNoteField = View.findDrawableById("step_note") as Text;
        stepNoteField.locY = stepNoteField.locY + 30;

        // Set text
        labelField.setText(Rez.Strings.label);
        stepNameField.setText(currStepName);
        stepNoteField.setText(currStepNote);

        // Sys.println("[BetterHiitDatafieldView] Layout config completed.");
    }           

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {
        var currentStepInfo = Activity.getCurrentWorkoutStep() as Activity.WorkoutStepInfo;
        if (currentStepInfo != null) {
            currStepName = currentStepInfo.name;
            currStepNote = currentStepInfo.notes;
        } else {
            var str_unknown = WatchUi.loadResource(Rez.Strings.unknown) as String;
            currStepName = str_unknown;
            currStepNote = str_unknown;
        }

        Sys.println("[BetterHiitDatafieldView::compute]: " + currStepName + " | " + currStepNote );
    }



    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        // Sys.println("[BetterHiitDatafieldView] Updating...");
        // Set the background color
        // var bgColor = Graphics.COLOR_ORANGE;
        // (View.findDrawableById("Background") as Text).setColor(getBackgroundColor());

        // Set the calculated values on the UI
        var stepNameField = View.findDrawableById("step_name") as Text;
        stepNameField.setText(currStepName);

        var stepNoteField = View.findDrawableById("step_note") as Text;
        stepNoteField.setText(currStepNote);

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);

        // Sys.println("[BetterHiitDatafieldView] Updated.");
    }

    // function onWorkoutStarted() as Void {
    //     Sys.println("[HiitDataFieldView] onWorkoutStarted");
    // }

    // function onWorkoutStepComplete() as Void {
    //     Sys.println("[HiitDataFieldView::onWorkoutStepComplete] ");
    // }

}
