import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "display", "input", "editButton", "saveButton", "cancelButton" ]

  connect() {
    this.showDisplay()
  }

  showEdit() {
    this.displayTarget.style.display = 'none'
    this.editButtonTarget.style.display = 'none'
    this.inputTarget.style.display = ''
    this.saveButtonTarget.style.display = ''
    this.cancelButtonTarget.style.display = ''
    
    // Focus on the input and move the cursor to the end
    this.inputTarget.focus()
    const length = this.inputTarget.value.length
    this.inputTarget.setSelectionRange(length, length)
  }

  showDisplay() {
    this.displayTarget.style.display = ''
    this.editButtonTarget.style.display = ''
    this.inputTarget.style.display = 'none'
    this.saveButtonTarget.style.display = 'none'
    this.cancelButtonTarget.style.display = 'none'
  }

  save() {
    const id = this.element.dataset.id
    const value = this.inputTarget.value

    fetch(`/admin/fleet/${id}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ fleet: { livery: value } })
    })
    .then(response => response.json())
    .then(data => {
      if (data.errors) {
        console.error(data.errors)
      } else {
        this.displayTarget.textContent = data.livery
        this.showDisplay()
      }
    })
    .catch(error => console.error('Error:', error))
  }

  cancel() {
    this.inputTarget.value = this.displayTarget.textContent
    this.showDisplay()
  }
}