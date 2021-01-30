import Vue from 'vue';
import axios from './wrapper_axios';

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    data: {
      is_like: false,
      likes_count: 0,
      badge: {
        'badge-danger': false,
        'badge-secondary': false,
        badge: true,
        'badge-pill': true
      }
    },
    mounted: function() {
      const dataset = document.getElementById('like-badge').dataset;
      this.likes_count = dataset.likesCount;
      const is_like = dataset.alreadyLike;
      this.is_like = (is_like === 'true');
      if (this.is_like) { Vue.set(this.badge, 'badge-danger', true); }
      else { Vue.set(this.badge, 'badge-secondary', true); }
    },
    methods: {
      onClick: function(product_id) {
        if (this.is_like) {
          axios.delete(`/api/products/${product_id}/like`, { withCredentials: true })
          .then((response) => {
            this.is_like = false;
            this.likes_count--;
            this.badge = Object.assign({}, this.badge, { 'badge-danger': false, 'badge-secondary': true });
          })
          .catch((error) => {
            console.error(error);
          });
        } else {
          axios.post(`/api/products/${product_id}/likes`, { withCredentials: true })
          .then((response) => {
            this.is_like = true;
            this.likes_count++;
            this.badge = Object.assign({}, this.badge, { 'badge-danger': true, 'badge-secondary': false });
          })
          .catch((error) => {
            console.log(error);
          })
        }
      }
    }
  }).$mount('#like-form');
});