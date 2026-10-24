<script setup lang="ts">
import { responsiveCssLength } from '@/main/ui/responsive-unit'
import { computed } from 'vue'

const props = withDefaults(defineProps<{ animated?: boolean; size?: number }>(), {
  animated: false,
  size: 60,
})

const size = computed(() => responsiveCssLength(props.size))
</script>
<template>
  <span
    class="shore-load"
    :data-animated="animated || undefined"
    :style="{ height: size, width: size }"
    role="status"
    aria-label="Loading"
  >
    <span class="shore-load__ring shore-load__ring--outer" />
    <span class="shore-load__ring shore-load__ring--inner" />
    <span class="shore-load__bars" aria-hidden="true">
      <i /><i /><i /><i /><i />
    </span>
  </span>
</template>
<style scoped lang="less">
.shore-load {
  position: relative;
  display: inline-grid;
  flex: 0 0 auto;
  place-items: center;
}

.shore-load__ring {
  position: absolute;
  border-radius: 50%;
  border-style: dashed;
}

.shore-load__ring--outer {
  width: 86%;
  height: 86%;
  border-width: 2.5px;
  border-color: #ff7347;
}

.shore-load__ring--inner {
  width: 62%;
  height: 62%;
  border-width: 2px;
  border-color: #8cf266;
}

.shore-load__bars {
  display: flex;
  align-items: flex-end;
  justify-content: center;
  width: 46%;
  height: 34%;
  gap: 8%;
}

.shore-load__bars i {
  display: block;
  width: 14%;
  height: 42%;
  border-radius: 999px;
  background: #ff7347;
  transform-origin: center bottom;
}

.shore-load__bars i:nth-child(even) {
  background: #8cf266;
}

.shore-load[data-animated] .shore-load__ring--outer {
  animation: shore-load-spin 2.4s linear infinite;
}

.shore-load[data-animated] .shore-load__ring--inner {
  animation: shore-load-spin 1.8s linear infinite reverse;
}

.shore-load[data-animated] .shore-load__bars i {
  animation: shore-load-bar 0.9s ease-in-out infinite alternate;
}

.shore-load[data-animated] .shore-load__bars i:nth-child(2) {
  animation-duration: 0.98s;
}

.shore-load[data-animated] .shore-load__bars i:nth-child(3) {
  animation-duration: 0.86s;
}

.shore-load[data-animated] .shore-load__bars i:nth-child(4) {
  animation-duration: 1.05s;
}

.shore-load[data-animated] .shore-load__bars i:nth-child(5) {
  animation-duration: 0.94s;
}

@keyframes shore-load-spin {
  to {
    transform: rotate(360deg);
  }
}

@keyframes shore-load-bar {
  from {
    transform: scaleY(0.4);
  }

  to {
    transform: scaleY(1);
  }
}
</style>
