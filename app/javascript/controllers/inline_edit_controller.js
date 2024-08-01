import { Controller } from "@hotwired/stimulus"

/**
 * InlineEditController
 * 
 * This Stimulus controller manages inline editing functionality for both text and number inputs.
 * It handles showing/hiding edit controls, cursor positioning, and AJAX updates.
 */
export default class extends Controller {
  static targets = [ "display", "input", "editButton", "saveButton", "cancelButton" ]
  static values = {
    updateUrl: String,
    paramName: String,
    modelName: String
  }

  /**
   * Initialize the controller
   */
  connect() {
    this.showDisplay()
  }

  /**
   * Switch to edit mode
   * Handles both text and number inputs, ensuring correct cursor positioning
   */
  showEdit() {
    // Hide display elements and show edit elements
    this.displayTarget.style.display = 'none'
    this.editButtonTarget.style.display = 'none'
    this.inputTarget.style.display = ''
    this.saveButtonTarget.style.display = ''
    this.cancelButtonTarget.style.display = ''

    if (this.inputTarget.type === 'number') {
      // Special handling for number inputs to ensure correct cursor positioning
      const currentValue = this.inputTarget.value
      this.inputTarget.type = 'text'  // Temporarily change to text input
      this.inputTarget.value = currentValue
      this.inputTarget.focus()
      const length = this.inputTarget.value.length
      this.inputTarget.setSelectionRange(length, length)
      
      // Revert back to number type after a short delay
      setTimeout(() => {
        this.inputTarget.type = 'number'
      }, 0)
    } else {
      // Standard handling for text inputs
      this.inputTarget.focus()
      const length = this.inputTarget.value.length
      this.inputTarget.setSelectionRange(length, length)
    }
  }

  /**
   * Switch back to display mode
   */
  showDisplay() {
    // Show display elements and hide edit elements
    this.displayTarget.style.display = ''
    this.editButtonTarget.style.display = ''
    this.inputTarget.style.display = 'none'
    this.saveButtonTarget.style.display = 'none'
    this.cancelButtonTarget.style.display = 'none'
  }

  /**
   * Save the edited value via AJAX
   */
  save() {
    const id = this.element.dataset.id
    const value = this.inputTarget.value
    const params = {}
    params[this.paramNameValue] = value

    // Send PATCH request to update the value
    fetch(this.updateUrlValue.replace(':id', id), {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ [this.modelNameValue]: params })
    })
    .then(response => response.json())
    .then(data => {
      if (data.errors) {
        console.error(data.errors)
      } else {
        // Update display with new value and switch back to display mode
        this.displayTarget.textContent = data[this.paramNameValue] || data.livery
        this.showDisplay()
      }
    })
    .catch(error => console.error('Error:', error))
  }

  /**
   * Cancel editing and revert to original value
   */
  cancel() {
    this.inputTarget.value = this.displayTarget.textContent
    this.showDisplay()
  }
}