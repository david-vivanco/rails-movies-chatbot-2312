// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

// document.addEventListener("turbo:load", () => {
//   const form = document.getElementById("new_message");

//   if (form) {
//     form.scrollIntoView();
//   }
// });

// document.addEventListener("turbo:load", () => {
//   const form = document.getElementById("new_message");

//   if (form) {
//     window.scrollTo({
//       top: form.offsetTop - 200,
//       behavior: "auto"
//     });
//   }
// });

// document.addEventListener("turbo:load", () => {
//   const exchanges = document.getElementById("exchanges");

//   if (exchanges) {
//     exchanges.lastElementChild?.scrollIntoView();
//   }
// });

document.addEventListener("turbo:load", () => {
const form = document.getElementById("new_message");

if (form) {
window.scrollTo({
top: form.offsetTop - 200,
behavior: "auto"
});
}
});
