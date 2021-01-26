import Vue from 'vue';

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    data: {
      show_images: [false, false, false, false],
      files: [null, null, null, null]
    },
    methods: {
      onChange: function(input, index) {
        const image = this.$refs[input].files[0];
        const reader = new FileReader();
        reader.readAsDataURL(image);
        const self = this;
        reader.onload = function() {
          self.files.splice(index, 1, reader.result);
        };
        this.show_images.splice(index, 1, true);
      }
    }
  }).$mount('#new-product-images');
});

document.addEventListener('turbolinks:visit', () => {
  vue.$destroy();
  vue = {};
})