// Simple interactions for CareCue marketing site

document.addEventListener("DOMContentLoaded", () => {
  const navToggle = document.querySelector("[data-nav-toggle]");
  const navLinks = document.querySelector("[data-nav-links]");

  if (navToggle && navLinks) {
    navToggle.addEventListener("click", () => {
      navLinks.classList.toggle("is-open");
    });

    navLinks.addEventListener("click", (event) => {
      if (event.target.matches("a")) {
        navLinks.classList.remove("is-open");
      }
    });
  }
});

