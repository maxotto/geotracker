<template>
  <div id="app">
    {{timestamp}}
    <GmapMap
      ref="mapRef"
      :center="{ lat: 54.55332, lng: 35.9772323 }"
      :zoom="15"
      map-type-id="terrain"
      style="width: 1920px; height: 1080px"
    >
      <GmapMarker
        :key="index"
        v-for="(m, index) in markers"
        :position="m.position"
        :clickable="true"
        :draggable="true"
        @click="center = m.position"
      />
      <gmap-polyline v-bind:path.sync="path" v-bind:options="{ strokeColor:'#FF0000'}"></gmap-polyline>
    </GmapMap>
  </div>
</template>

<script>
import { gmapApi } from "gmap-vue";
export default {
  name: "App",
  components: {},
  data: function () {
    return {
      timestamp: null,
      markers: [],
      pathes: {
        Andrey: [],
      },
      path: [],
    };
  },
  methods: {
    
  },
  watch: {
    timestamp() {
      // console.log(val)
    }
  },
  computed: {
    google: gmapApi,
  },
  mqtt: {
    "delivery/andrey/location"(data) {
      const d = JSON.parse(new TextDecoder("utf-8").decode(data));
      console.log(d);
      this.markers = [
        {
          name: "Andrey",
          position: {
            lat: d.latitude,
            lng: d.longitude,
          },
        },
      ];
      this.path.push({ lat: d.latitude, lng: d.longitude });
    },
  },
  mounted() {
    this.$mqtt.subscribe("delivery/andrey/location");
    setInterval(() => {
      this.timestamp = Date.now()
      }, 3000)
  },
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
