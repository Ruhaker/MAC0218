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
    <form v-on:submit.prevent='changed_group' v-on:focusout='delay_restore'>
      <div v-if='group_obj && is_group' class='toolbar'>
        <div class='left toolbar'>
          <move-icon v-if='parentobj && parentobj.can_modify' rootClass='handle header-icon' w='20' h='20' />
            <input type='text' class='editable-text title' ref='group_title' @focus='title_focus = true' @blur='title_focus = false'
                @dblclick='enable_editing' v-model='group_obj.name' :readonly='!editing'/>
            <input type="submit" hidden />
        </div>
        <div class='spacer'/>
        <div class='right toolbar'>
          <div v-if='group_obj.min_credits || editing'>
          Créditos: {{group_obj.done_credits}} / 
            <input type='number' class='editable-text' ref='group_min_credits' @focus='min_cred_focus = true' @blur='min_cred_focus = false'
                @dblclick='enable_editing' v-model.number='group_obj.min_credits' :readonly='!editing'/>
            <input type="submit" hidden />
          </div>
          <div v-if='group_obj.min_subjects || editing'>
          Matérias: {{group_obj.done_credits}} / 
            <input type='number' class='editable-text' ref='group_min_subjects' @focus='min_sub_focus = true' @blur='min_sub_focus = false'
                @dblclick='enable_editing' v-model.number='group_obj.min_subjects' :readonly='!editing'/>
            <input type="submit" hidden />
          </div>
          <transition name='toolbar-actions'>
            <div v-if='group_obj.can_modify'>
              <div v-if='editing' v-on:click="disable_editing">
                <check-icon rootClass='header-icon' w='25' h='25' />
              </div>
              <div v-else style='display: flex'>
                <div v-if='!isroot' v-on:click="delete_group">
                  <trash-icon rootClass='header-icon' w='25' h='25' />
                </div>
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
    </form>
    <hr v-if='group_obj && is_group'>
  </div>
</template>

<script>
import auth from '../auth';
import util from '../util';

import regeneratorRuntime from 'regenerator-runtime';

import AddIcon from 'vue-ionicons/dist/md-add.vue';
import CreateIcon from 'vue-ionicons/dist/md-create.vue';
import CheckIcon from 'vue-ionicons/dist/md-checkmark.vue';
import MoveIcon from 'vue-ionicons/dist/md-move.vue';
import TrashIcon from 'vue-ionicons/dist/md-trash.vue';

import { Chrome } from 'vue-color';

export default {
  name: 'group-header',
  props: {
    groupobj: { default: null },
    parentobj: { default: null },
    isroot: { default: true }
  },
  data() {
    return {
      is_editing: false,
      old_obj: null,
      editing: false,
      title_focus: false,
      min_cred_focus: false,
      min_sub_focus: false
    };
  },
  components: {
    'chrome-color-picker': Chrome,
    AddIcon,
    CreateIcon,
    CheckIcon,
    MoveIcon,
    TrashIcon
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
  mounted() {
    if (this.group_obj && this.group_obj.new) this.enable_editing();
  },
  methods: {
    async delete_group() {
      try {
        await auth.request('group/destroy', { group_id: this.group_obj.id });
      } catch (ignore) {}

      this.$emit('update-indices');

      this.parentobj.children.splice(
        this.parentobj.children.findIndex(
          element => element.id === this.group_obj.id
        ),
        1
      );
    },
    delay_restore() {
      this.$nextTick(() => this.restore_editing());
    },
    // Change group
    changed_group(evn) {
      if (this.group_obj.new) {
        auth
          .request('group/create', {
            parent_group_id: this.parentobj.id,
            name: this.group_obj.name,
            min_credits: this.group_obj.min_credits,
            min_subjects: this.group_obj.min_subjects,
            ordering: this.group_obj.new_index
          })
          .then(result => {
            delete this.group_obj.new;
            delete this.group_obj.new_index;
            this.$emit('reload-group', { group_id: result.data.id });
          });
      } else {
        // Get only changed values
        var changes = {};
        Object.keys(this.old_obj).forEach(key => {
          if (this.group_obj[key] !== this.old_obj[key])
            changes[key] = this.group_obj[key];
        });

        changes.group_id = this.group_obj.id;
        auth
          .request('group/update', changes)
          .then(() => {
            console.log('updated!');
            this.disable_editing();
          })
          .catch(() => this.restore_editing());
      }
      this.disable_editing();
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
        this.$refs.group_title.focus();
      }
    },
    // Restore editing
    restore_editing() {
      if (this.title_focus || this.min_cred_focus || this.min_sub_focus) return;
      if (this.group_obj.new) this.delete_group();
      this.disable_editing();
      Object.keys(this.old_obj).forEach(key => {
        this.group_obj[key] = this.old_obj[key];
      });
    },
    // Enable editing
    disable_editing() {
      this.editing = false;
    },
    // Adds child to this group
    add_child() {
      this.$emit('add-child', {
        type: 'group',
        new: true,
        can_modify: true
      });
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

