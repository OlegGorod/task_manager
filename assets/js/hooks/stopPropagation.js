let StopPropagation = {
  mounted() {
    this.el.addEventListener("click", (event) => {
      if (
        !event.target.closest("button[phx-click='close_modal']") &&
        !event.target.closest("button[phx-click='close_delete_modal']") &&
        !event.target.closest("button[phx-click='delete_task']")
      ) {
        event.stopPropagation(); 
      }
    });
  },
};

export default StopPropagation;
