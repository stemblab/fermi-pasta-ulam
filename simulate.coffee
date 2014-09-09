class Simulation

    constructor: (@spec) ->
        @step = 0
        @stopClicked = false
        if $blab.simTimerId
            # Previous simulation running
            @stop()
            @start()  # No start delay if restarted
        else
            delay = @spec.delay ? 0
            setTimeout (=> @start()), delay 
        
    start: ->
        $blab.stopButton = new StopButton => @stopClicked = true
        @simulate()      
        
    simulate: ->
        $blab.stopButton.text "Stop (step: #{@step})"
        sim = @spec.step(@step) and not @stopClicked
        if sim
            $blab.simTimerId = setTimeout (=> @simulate()), 0 
        else
            @spec.end?()
            @stop()
        @step++
        
    stop: ->
        clearTimeout $blab.simTimerId
        $blab.stopButton.remove()
        $blab.simTimerId = null
        
class StopButton

    id: "stop_simulation_button"

    constructor: (@stop) ->
        @button = $ "##{@id}"
        @button.remove() if @button.length
        @button = $ "<button>",
            id: @id
            type: "button"
            text: "Stop"
            title: "Stop simulation"
            click: => @stop()
            css:
                fontSize: "7pt"
                width: "140px"
                marginLeft: "5px"
        $("#run_button_container").append @button
        
    text: (t) ->
        @button.text t
        
    remove: -> @button.remove()
        
$blab.Simulation = Simulation
$blab.simulate = (spec) -> new Simulation spec


