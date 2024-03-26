<template>
  <div v-if="siteLinks[0]" class="links">
    <div class="line">
      <Icon size="20">
        <Link />
      </Icon>
      <span class="title">网站列表</span>
    </div>
    <!-- 网站列表 -->
    <Swiper
      v-if="siteLinks[0]"
      :modules="[Pagination, Mousewheel]"
      :slides-per-view="1"
      :space-between="40"
      :pagination="{
        el: '.swiper-pagination',
        clickable: true,
        bulletElement: 'div',
      }"
      :mousewheel="true"
    >
      <SwiperSlide v-for="site in siteLinksList" :key="site">
        <el-row class="link-all" :gutter="20">
          <el-col v-for="(item, index) in site" :span="8" :key="item">
            <div
              class="item cards"
              :style="index < 3 ? 'margin-bottom: 21px' : null"
              @click="jumpLink(item)"
            >
              <Icon size="26">
                <component :is="siteIcon[item.icon]" />
              </Icon>
              <span class="name text-hidden">{{ item.name }}</span>
              <!-- 显示站点状态的小圆点 -->
              <div class="status-dot" :class="item.css"></div>
            </div>
          </el-col>
        </el-row>
      </SwiperSlide>
      <div class="swiper-pagination" />
    </Swiper>
  </div>
</template>

<script setup>
import { Icon } from "@vicons/utils";
// 可前往 https://www.xicons.org 自行挑选并在此处引入
import { Link, Blog, CompactDisc, Cloud, Compass, Book, Fire, LaptopCode,Toolbox } from "@vicons/fa"; // 注意使用正确的类别
import { mainStore } from "@/store";
import { Swiper, SwiperSlide } from "swiper/vue";
import { Pagination, Mousewheel } from "swiper";
import siteLinks from "@/assets/siteLinks.json";
import { onMounted } from "vue";

const store = mainStore();

// 计算网站链接
const siteLinksList = computed(() => {
  const result = [];
  for (let i = 0; i < siteLinks.length; i += 6) {
    const subArr = siteLinks.slice(i, i + 6);
    result.push(subArr);
  }
  return result;
});

// 根据状态获取样式类
const getStatusClass = (status, delay) => {
  return {
    'status-dot': true,
    'status-green': status === 'green',
    'status-red': status === 'red',
    'blink': status !== 'green', // 如果状态不是绿色，则添加闪烁类
    [`blink-${Math.floor(delay * 10)}`]: status !== 'green' // 根据延迟调整闪烁频率
  };
};

// 检查站点可访问性
const pingSites = () => {
  siteLinks.forEach(site => {
    const img = new Image();
    const start = performance.now();

    // 设置超时计时器
    const timeoutId = setTimeout(() => {
      site.status = 'timeout';
      site.delay = Infinity;
    }, 2000); // 设置2秒超时

    img.onload = () => {
      clearTimeout(timeoutId); // 清除超时计时器
      const end = performance.now();
      const delay = end - start;
      console.log("耗时：" + delay + "ms");

      if (delay < 500) {
        site.status = 'green';
      } else {
        site.status = 'red';
      }

      site.delay = delay;
    };

    img.onerror = () => {
      clearTimeout(timeoutId); // 清除超时计时器
      site.status = 'red';
      site.delay = Infinity;
    };

    site.css = getStatusClass(site.status, site.delay);
    img.src = site.link + '?timestamp=' + new Date().getTime();
  });
};

onMounted(() => {
  // 每 5 秒检查一次站点的可访问性
  setInterval(pingSites, 5000);
});



// 网站链接图标
const siteIcon = {
  Blog,
  Cloud,
  CompactDisc,
  Compass,
  Book,
  Fire,
  LaptopCode,
  Toolbox
};




// 链接跳转
const jumpLink = (data) => {
  if (data.name === "音乐" && store.musicClick) {
    if (typeof $openList === "function") $openList();
  } else {
    window.open(data.link, "_blank");
  }
};

onMounted(() => {
  console.log(siteLinks);
});
</script>

<style lang="scss" scoped>
.links {
  .line {
    margin: 2rem 0.25rem 1rem;
    font-size: 1.1rem;
    display: flex;
    align-items: center;
    animation: fade 0.5s;
    .title {
      margin-left: 8px;
      font-size: 1.15rem;
      text-shadow: 0 0 5px #00000050;
    }
  }
  .swiper {
    left: -10px;
    width: calc(100% + 20px);
    padding: 5px 10px 0;
    z-index: 0;
    .swiper-slide {
      height: 100%;
    }
    .swiper-pagination {
      position: static;
      margin-top: 4px;
      :deep(.swiper-pagination-bullet) {
        background-color: #fff;
        width: 18px;
        height: 4px;
        border-radius: 4px;
        transition: opacity 0.3s;
        &:hover {
          opacity: 1;
        }
      }
    }
  }
  .link-all {
    height: 220px;
    .item {
      height: 100px;
      width: 100%;
      display: flex;
      align-items: center;
      flex-direction: row;
      justify-content: center;
      padding: 0 10px;
      animation: fade 0.5s;

      &:hover {
        transform: scale(1.02);
        background: rgb(0 0 0 / 40%);
        transition: 0.3s;
      }

      &:active {
        transform: scale(1);
      }

      .name {
        font-size: 1.1rem;
        margin-left: 8px;
      }
      @media (min-width: 720px) and (max-width: 820px) {
        .name {
          display: none;
        }
      }
      @media (max-width: 720px) {
        height: 80px;
      }
      @media (max-width: 460px) {
        flex-direction: column;
        .name {
          font-size: 1rem;
          margin-left: 0;
          margin-top: 8px;
        }
      }
    }
    @media (max-width: 720px) {
      height: 180px;
    }
  }

  .status-dot {
    width: 15px;
    height: 15px;
    border-radius: 50%;
    background-color: #ccc; /* 默认颜色 */
    position: absolute; /* 绝对定位 */
    top: 10px; /* 位于容器的顶部 */
    left: 10px; /* 位于容器的左侧 */
  }

  /* 状态样式 */
  .status-green {
    background-color: #00ff00; /* 绿色 */
  }

  .status-red {
    background-color: #ff0000; /* 红色 */
  }

  /* 闪烁样式 */
  .blink {
    animation: blink 1s infinite; /* 1s 是闪烁的周期，infinite 表示无限循环 */
  }

  /* 根据延迟调整闪烁频率的样式 */
  @keyframes blink {
    0% { opacity: 1; }
    50% { opacity: 0; }
    100% { opacity: 1; }
  }

  .blink-0 {
    animation-duration: 0s; /* 0s 是闪烁的周期，即不闪烁 */
  }

  /* 根据 delay * 10 的值来调整闪烁频率的样式 */
  .blink-1 {
    animation-duration: 0.1s; /* 闪烁频率为 100ms */
  }

  .blink-2 {
    animation-duration: 0.2s; /* 闪烁频率为 200ms */
  }

}
</style>
