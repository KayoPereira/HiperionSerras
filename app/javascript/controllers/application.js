import { Application } from "@hotwired/stimulus"
import PetSelectorController from "controllers/active_controller"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

application.register("pet-selector", PetSelectorController)
export { application }
