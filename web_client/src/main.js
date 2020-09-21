import Vue from "vue";
import App from "./App.vue";
import * as GmapVue from "gmap-vue";
import VueMqtt from "vue-mqtt";

Vue.use(
  VueMqtt,
  "ws://ec2-18-218-34-205.us-east-2.compute.amazonaws.com:9001",
  {
    clientId: "WebClient-" + parseInt(Math.random() * 100000),
  }
);
/*
Vue.use(VueMqtt, "ws://mikhailichenko.ru:9001", {
  clientId: "WebClient-" + parseInt(Math.random() * 100000),
});
*/

Vue.use(GmapVue, {
  load: {
    key: "AIzaSyARIMiX_C7rE4U-pM6nih2n2z2z0YfhrfY",
    libraries: "places",
  },
  installComponents: true,
});

Vue.config.productionTip = false;

new Vue({
  render: (h) => h(App),
}).$mount("#app");
