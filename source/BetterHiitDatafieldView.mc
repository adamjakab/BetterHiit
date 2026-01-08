import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.System as Sys;

class BetterHiitDatafieldView extends WatchUi.DataField {

    hidden var currStepType as String;
    hidden var currStepName as String;
    hidden var currStepNote as String;

    hidden var requiredStepType as String;

    function initialize() {
        DataField.initialize();
        
        currStepType = ""; // The step type currently displayed (will be updated on next initLayout call)
        requiredStepType = "EXERCISE"; // The step type calculated and to be displayed on the next update

        currStepName = Rez.Strings.unknown as String;
        currStepNote = Rez.Strings.unknown as String;



        Sys.println("[BetterHiitDatafieldView] Initialized");
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void {
        // Sys.println("[BetterHiitDatafieldView] Layout config started...");
        
        // Init the correct layout
        initLayout(dc);
        
        // Sys.println("[BetterHiitDatafieldView] Layout config completed.");
    }

    function initLayout(dc as Dc) as Void {
        // Do not re-initialize if the layout is already correct
        if (currStepType == requiredStepType) {
            return;
        }

        // Store the new layout type
        currStepType = requiredStepType;

        // Initialize the correct layout
        if (currStepType == "EXERCISE") {
            initLayoutExercise(dc);
        } else if (currStepType == "REST") {
            initLayoutRest(dc);
        }
    }

    function initLayoutExercise(dc as Dc) as Void {
        // var obscurityFlags = DataField.getObscurityFlags();
        View.setLayout(Rez.Layouts.ExerciseLayout(dc));

        var labelField = View.findDrawableById("label") as Text;
        labelField.locY = labelField.locY - 90;
        
        var stepNameField = View.findDrawableById("step_name") as Text;
        stepNameField.locY = stepNameField.locY - 30;
    
        var stepNoteField = View.findDrawableById("step_note") as Text;
        stepNoteField.locY = stepNoteField.locY + 30;

        // Set text
        labelField.setText(Rez.Strings.label);
        // stepNameField.setText(currStepName);
        // stepNoteField.setText(currStepNote);
    }

    function initLayoutRest(dc as Dc) as Void {
        // var obscurityFlags = DataField.getObscurityFlags();
        View.setLayout(Rez.Layouts.RestLayout(dc));

        var labelField = View.findDrawableById("label") as Text;
        labelField.locY = labelField.locY - 60;
        
        var stepNameField = View.findDrawableById("step_name") as Text;
        stepNameField.locY = stepNameField.locY + 30;
    
        // Set text
        labelField.setText("RESTING");
        // stepNameField.setText(currStepName);
    }

    
    /**
     * Compute the current HIIT workout step information.
     * Note that compute() and onUpdate() are asynchronous, and there is no 
     * guarantee that compute() will be called before onUpdate().
     * @param info The current activity info.
     */
    function compute(info as Activity.Info) as Void {
        var str_unknown = WatchUi.loadResource(Rez.Strings.unknown) as String;
        var currentStepInfo = Activity.getCurrentWorkoutStep() as Activity.WorkoutStepInfo;
        // var nextStepInfo = Activity.getNextWorkoutStep() as Activity.WorkoutStepInfo;


        if (currentStepInfo != null) {
            // Determine the calculated step type (relative layout will be set on next onUpdate call)
            requiredStepType = "EXERCISE";
            if (currentStepInfo.intensity == Activity.WORKOUT_INTENSITY_REST) {
                requiredStepType = "REST";
            }

            if (currentStepInfo.name == null) {
                currStepName = str_unknown;
            } else {
                currStepName = currentStepInfo.name;
            }
            
            currStepNote = currentStepInfo.notes;
            

        } else {
            
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


        // Force layout update if necessary
        initLayout(dc);

        // Set the calculated values on the UI
        // var stepNameField = View.findDrawableById("step_name") as Text;
        // stepNameField.setText(currStepName);

        // var stepNoteField = View.findDrawableById("step_note") as Text;
        // stepNoteField.setText(currStepNote);

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
