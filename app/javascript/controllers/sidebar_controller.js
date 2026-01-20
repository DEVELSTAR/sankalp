import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        this.sidebar = document.getElementById("mobile-sidebar")
        this.overlay = document.getElementById("mobile-sidebar-overlay")
        this.closeButton = document.getElementById("close-sidebar")

        if (this.closeButton) {
            this.closeButton.addEventListener("click", this.close.bind(this))
        }
    }

    open() {
        if (this.sidebar) {
            this.sidebar.classList.remove("hidden")
            // Small delay to allow transition if needed, but for now just showing it
            requestAnimationFrame(() => {
                this.sidebar.classList.remove("translate-x-full")
            })
        }
        if (this.overlay) {
            this.overlay.classList.remove("hidden")
        }
    }

    close() {
        if (this.sidebar) {
            this.sidebar.classList.add("translate-x-full")
            // Wait for transition to finish before hiding
            setTimeout(() => {
                this.sidebar.classList.add("hidden")
            }, 300)
        }
        if (this.overlay) {
            this.overlay.classList.add("hidden")
        }
    }
}
