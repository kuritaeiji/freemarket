import Vue from 'vue';

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    data: {
      product: {
        category_id: '',
        status_ids: [],
        shipping_day_ids: [],
      },
      show_detail_form: false
    },
    methods: {
      onCategoryChange: function(event) {
        Vue.set(this.product, 'category_id', event.target.value);
      },
      onStatusChange: function(event) {
        if (event.target.checked) {
          this.product.status_ids.push(event.target.value);
        } else {
          const index = this.product.status_ids.indexOf(event.target.value);
          if (index >= 0) { this.product.status_ids.splice(index, 1); }
        }
      },
      onShippingDayChange: function(event) {
        if (event.target.checked) {
          this.product.shipping_day_ids.push(event.target.value);
        } else {
          const index = this.product.shipping_day_ids.indexOf(event.target.value);
          if (index >= 0) { this.product.shipping_day_ids.splice(index, 1); }
        }
      },
      onClick: function() {
        this.show_detail_form = !this.show_detail_form;
      }
    }
  }).$mount('#header');
});