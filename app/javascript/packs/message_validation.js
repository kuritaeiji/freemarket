import Vue from 'vue';

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    data: {
      is_longer: false
    },
    methods: {
      onInput: function(event) {
        this.is_longer = false;
        if (event.target.value.length > 200) { this.is_longer = true; }
      }
    }
  }).$mount('.message-form');
});