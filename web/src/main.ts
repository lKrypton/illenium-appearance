import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import './styles/themes.css'
import './styles/main.css'

import { library } from '@fortawesome/fontawesome-svg-core'
import {
  faUser, faUsers, faFaceMeh, faEye, faPaintbrush, faShirt, faGem, faPenNib, faPaw,
  faFaceSmile, faShoePrints, faArrowLeft, faArrowRight, faStreetView, faRotateLeft, faRotateRight, faCheck, faXmark,
  faChevronDown, faChevronLeft, faChevronRight, faTriangleExclamation,
  faMars, faVenus, faDroplet, faDna, faScissors, faPalette, faWandMagicSparkles,
  faVest, faPerson, faSocks, faNoteSticky, faMask, faShieldHalved, faBagShopping, faLink,
  faHatCowboy, faGlasses, faRing, faClock, faHourglass, faHeart, faFingerprint,
  faSun, faStar, faFire, faKitMedical, faTeeth, faTeethOpen, faTrash,
  faFloppyDisk, faRightFromBracket, faLightbulb, faChildReaching, faCrosshairs, faDownload, faArrowsRotate,
  faCloudArrowDown, faArrowRightArrowLeft, faClipboard, faLayerGroup, faPlay, faPlus
} from '@fortawesome/free-solid-svg-icons'

library.add(
  faUser, faUsers, faFaceMeh, faEye, faPaintbrush, faShirt, faGem, faPenNib,
  faFaceSmile, faShoePrints, faArrowLeft, faArrowRight, faStreetView, faRotateLeft, faRotateRight, faCheck, faXmark,
  faChevronDown, faChevronLeft, faChevronRight, faTriangleExclamation,
  faMars, faVenus, faPaw, faDroplet, faDna, faScissors, faPalette, faWandMagicSparkles,
  faVest, faPerson, faSocks, faNoteSticky, faMask, faShieldHalved, faBagShopping, faLink,
  faHatCowboy, faGlasses, faRing, faClock, faHourglass, faHeart, faFingerprint,
  faSun, faStar, faFire, faKitMedical, faTeeth, faTeethOpen, faTrash,
  faFloppyDisk, faRightFromBracket, faLightbulb, faChildReaching, faCrosshairs, faDownload, faArrowsRotate,
  faCloudArrowDown, faArrowRightArrowLeft, faClipboard, faLayerGroup, faPlay, faPlus
)

const app = createApp(App)
app.use(createPinia())
app.mount('#app')
