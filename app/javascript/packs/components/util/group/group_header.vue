<template>
  <div id='header'>
    <!-- If Subject -->
    <div v-if='group_obj && !is_group' class='toolbar'>
      <div class='left toolbar'>
        <move-icon v-if='parentobj && parentobj.can_modify' rootClass='handle header-icon' w='20' h='20' />
        <div>{{group_obj.code}} - {{group_obj.name}}</div>
      </div>
      <div class='spacer'/>
      <div class='right toolbar'>
      </div>
    </div>
    <!-- If Group -->
    <div v-if='group_obj && is_group' class='toolbar'>
      <div class='left toolbar'>
        <move-icon v-if='parentobj && parentobj.can_modify' rootClass='handle header-icon' w='20' h='20' />
        <form v-on:submit.prevent='changed_group'>
          <input type='text' class='editable-text title' ref='group_title' v-on:focusout='disable_editing' v-on:dblclick='enable_editing' v-model='group_obj.name' :readonly='!editing'/>
          <input type="submit" hidden />
        </form>
      </div>
      <div class='spacer'/>
      <div class='right toolbar'>
        Créditos: {{group_obj.done_credits}} / 
        <form v-on:submit.prevent='changed_group'>
          <input type='number' class='editable-text' ref='group_title' v-on:focusout='disable_editing' v-on:dblclick='enable_editing' v-model='group_obj.min_credits' :readonly='!editing'/>
          <input type="submit" hidden />
        </form>
        <transition name='toolbar-actions'>
          <div v-if='group_obj.can_modify'>
            <div v-if='editing' v-on:click="disable_editing">
              <check-icon rootClass='header-icon' w='25' h='25' />
            </div>
            <div v-else style='display: flex'>
              <div v-on:click="enable_editing">
                <create-icon rootClass='header-icon' w='25' h='25' />
              </div>
              <div v-on:click="add_child">
                <add-icon rootClass='header-icon' w='25' h='25' />
              </div>
            </div>
          </div>
        </transition>
      </div>
    </div>
    <hr v-if='group_obj && is_group'>
  </div>
</template>

<script>
import auth from '../auth';
import util from '../util';

import AddIcon from 'vue-ionicons/dist/md-add.vue';
import CreateIcon from 'vue-ionicons/dist/md-create.vue';
import CheckIcon from 'vue-ionicons/dist/md-checkmark.vue';
import MoveIcon from 'vue-ionicons/dist/md-move.vue';

import { Chrome } from 'vue-color';

export default {
  name: 'group-header',
  props: {
    groupobj: { default: null },
    parentobj: { default: null }
  },
  data() {
    return { editing: false, old_obj: null };
  },
  components: {
    'chrome-color-picker': Chrome,
    AddIcon,
    CreateIcon,
    CheckIcon,
    MoveIcon
  },
  computed: {
    group_obj() {
      return this.groupobj;
    },
    // Is it a group?
    is_group() {
      return this.group_obj.type == 'group';
    }
  },
  methods: {
    // Change group
    changed_group(evn) {
      this.disable_editing();

      // Get only changed values
      var changes = {};
      for (let key in this.old_obj) {
        if (this.group_obj[key] != this.old_obj[key])
          changes[key] = this.group_obj[key];
      }

      changes.group_id = this.group_obj.id;
      auth
        .request('group/update', changes)
        .then(() => {
          console.log('updated!');
          this.disable_editing();
        })
        .catch(() => this.restore_editing());
    },
    // Enable editing
    enable_editing() {
      if (this.group_obj.can_modify) {
        this.editing = true;
        this.old_obj = util.pick(this.group_obj, [
          'name',
          'min_credits',
          'min_subjects'
        ]);
      }
    },
    // Restore editing
    restore_editing() {
      this.disable_editing();
      for (let key in Object.keys(this.old_obj))
        this.group_obj[key] = this.old_obj[key];
    },
    // Enable editing
    disable_editing() {
      this.editing = false;
    },
    // Adds child to this group
    add_child() {
      this.$emit('add-child', { type: 'group' });
    }
  }
};
</script>

<style lang="scss" scoped>
.header-icon {
  color: #555;
  height: 25px;
  cursor: pointer;
  width: 25px;
}

.header-icon:hover {
  color: #111;
}

// Toolbar transitions
.toolbar-actions-enter-active,
.toolbar-actions-leave-active {
  transition: opacity 0.5s;
}

.toolbar-actions-enter,
.toolbar-actions-leave-to {
  opacity: 0;
}

// Draggable styles
.draggable-ghost {
  background-color: red;
  opacity: 50%;
}

// Editable text fields
.editable-text.title {
  width: 200pt;
}

.editable-text.title {
  width: 200pt;
}

.editable-text:read-only {
  border: none;
  background-color: #0000;
  color: #000;
  cursor: default;
}
</style>

