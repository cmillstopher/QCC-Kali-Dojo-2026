document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[data-checklist]").forEach((list) => {
    const boxes = [...list.querySelectorAll('input[type="checkbox"]')];
    const output = list.querySelector("[data-progress]");

    function updateProgress() {
      const done = boxes.filter((box) => box.checked).length;
      if (output) output.textContent = `${done} of ${boxes.length} steps completed`;
    }

    boxes.forEach((box) => box.addEventListener("change", updateProgress));
    updateProgress();
  });
});
