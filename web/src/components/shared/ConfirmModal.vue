<script setup lang="ts">
import { computed } from 'vue'
import { useAppearanceStore } from '@/stores/appearance'
import FaIcon from '@/components/shared/FaIcon.vue'

const store = useAppearanceStore()

const props = defineProps<{
  visible: boolean
  variant?: 'save' | 'exit'
  title?: string
  description?: string
  confirmText?: string
  cancelText?: string
}>()

const emit = defineEmits<{
  confirm: []
  cancel: []
}>()

const isSave = () => (props.variant ?? 'save') === 'save'

const resolvedTitle = computed(() =>
  props.title ?? (isSave()
    ? store.t('modal.save.title') || 'Save Appearance'
    : store.t('modal.exit.title') || 'Exit Shop')
)
const resolvedDescription = computed(() =>
  props.description ?? (isSave()
    ? store.t('modal.save.description') || 'Are you sure you want to save?'
    : store.t('modal.exit.description') || 'Your changes will not be saved.')
)
const resolvedConfirmText = computed(() =>
  props.confirmText ?? (isSave()
    ? store.t('modal.save.confirm') || 'Save'
    : store.t('modal.exit.confirm') || 'Exit')
)
const resolvedCancelText = computed(() =>
  props.cancelText ?? (isSave()
    ? store.t('modal.save.cancel') || 'Cancel'
    : store.t('modal.exit.cancel') || 'Cancel')
)
</script>

<template>
  <Teleport to="body">
    <Transition
      enter-active-class="transition-all duration-200 ease-out"
      enter-from-class="opacity-0 scale-95"
      enter-to-class="opacity-100 scale-100"
      leave-active-class="transition-all duration-150 ease-in"
      leave-from-class="opacity-100 scale-100"
      leave-to-class="opacity-0 scale-95"
    >
      <div
        v-if="visible"
        class="fixed inset-0 z-[999999] flex items-center justify-center"
        style="-webkit-transform: translateZ(0); transform: translateZ(0);"
      >
        <!-- Backdrop -->
        <div
          class="absolute inset-0"
          style="background: rgba(0,0,0,0.75);"
          @click="emit('cancel')"
        />

        <!-- Modal card -->
        <div
          class="relative flex flex-col"
          style="width: 360px; background: #0e0e0e; border: 1px solid rgba(255,255,255,0.07); border-radius: 14px; overflow: hidden; box-shadow: 0 32px 64px rgba(0,0,0,0.7), 0 0 0 1px rgba(255,255,255,0.03);"
        >
          <!-- Glow blob behind icon (decorative) -->
          <div
            class="absolute top-0 left-1/2"
            style="width: 200px; height: 120px; transform: translate(-50%, -40%); filter: blur(40px); pointer-events: none; border-radius: 50%;"
            :style="isSave()
              ? 'background: rgba(22,163,74,0.12);'
              : 'background: rgba(220,38,38,0.10);'"
          />

          <!-- Body -->
          <div class="relative flex flex-col items-center px-7 pt-7 pb-6 gap-4 text-center">

            <!-- Icon badge -->
            <div
              class="flex items-center justify-center rounded-full"
              style="width: 52px; height: 52px;"
              :style="isSave()
                ? 'background: rgba(22,163,74,0.12); border: 1px solid rgba(22,163,74,0.25);'
                : 'background: rgba(220,38,38,0.10); border: 1px solid rgba(220,38,38,0.25);'"
            >
              <span :style="isSave() ? 'color: #16a34a;' : 'color: #dc2626;'">
                <FaIcon
                  :icon="isSave() ? 'floppy-disk' : 'right-from-bracket'"
                  :size="22"
                />
              </span>
            </div>

            <!-- Title -->
            <div class="flex flex-col gap-1">
              <h3
                class="text-[15px] font-black uppercase tracking-widest leading-none font-display"
                style="color: #ffffff;"
              >
                {{ resolvedTitle }}
              </h3>
              <p class="text-[11px] leading-relaxed" style="color: #71717a;">
                {{ resolvedDescription }}
              </p>
            </div>

            <!-- Divider -->
            <div class="w-full" style="height: 1px; background: rgba(255,255,255,0.05);" />

            <!-- Action buttons -->
            <div class="flex w-full gap-3">
              <!-- Cancel -->
              <button
                class="flex-1 flex items-center justify-center gap-2 rounded-xl py-3 border transition-all duration-300"
                style="background: #111111; border-color: rgba(255,255,255,0.05); color: #a1a1aa; font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase;"
                @mouseenter="($event.currentTarget as HTMLElement).style.borderColor = 'rgba(255,255,255,0.15)'"
                @mouseleave="($event.currentTarget as HTMLElement).style.borderColor = 'rgba(255,255,255,0.05)'"
                @click="emit('cancel')"
              >
                <FaIcon icon="xmark" :size="12" />
                {{ resolvedCancelText }}
              </button>

              <!-- Confirm -->
              <button
                class="flex-1 flex items-center justify-center gap-2 rounded-xl py-3 border transition-all duration-300 shadow-2xl"
                :style="isSave()
                  ? {
                      background: '#061a11',
                      borderColor: '#10b981',
                      boxShadow: 'inset 0 0 15px rgba(16, 185, 129, 0.2)',
                      color: '#10b981',
                      fontSize: '10px',
                      fontWeight: '700',
                      letterSpacing: '0.1em',
                      textTransform: 'uppercase'
                    }
                  : {
                      background: '#1a0606',
                      borderColor: '#ef4444',
                      boxShadow: 'inset 0 0 15px rgba(239, 68, 64, 0.2)',
                      color: '#ef4444',
                      fontSize: '10px',
                      fontWeight: '700',
                      letterSpacing: '0.1em',
                      textTransform: 'uppercase'
                    }"
                @mouseenter="($event.currentTarget as HTMLElement).style.filter = 'brightness(1.2)'"
                @mouseleave="($event.currentTarget as HTMLElement).style.filter = 'brightness(1)'"
                @click="emit('confirm')"
              >
                <FaIcon :icon="isSave() ? 'check' : 'right-from-bracket'" :size="12" />
                {{ resolvedConfirmText }}
              </button>
            </div>

          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>
