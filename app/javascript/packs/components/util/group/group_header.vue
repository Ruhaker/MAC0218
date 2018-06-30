<template>
  <div id='header'>
    <form v-on:submit.prevent='changed_group' v-on:focusout='delay_save' ref='group_edit_form'>
      <div class='toolbar'>
        <div class='left toolbar'>
          <move-icon title='Mover' v-if='!footer && parentobj && parentobj.can_modify' rootClass='handle header-icon' w='20' h='20' />
          <input type='text' class='editable-text title' ref='group_title' @focus='title_focus = true' @blur='title_focus = false'
              @dblclick='enable_editing' v-if='group_obj' v-model='group_obj.name' :readonly='!editing'/>
        </div>
        <div class='right toolbar'>
          <div v-if='!is_group'>Progresso: {{group_obj.progress ? group_obj.progress : 'Não foi feito'}}</div>
          <div v-if='(group_obj && group_obj.min_credits) || editing'>
          Créditos: {{donecredits ? donecredits : '-'}} / 
            <input type='number' class='editable-text min' ref='group_min_credits' @focus='min_cred_focus = true' @blur='min_cred_focus = false'
                @dblclick='enable_editing' v-if='group_obj' v-model.number='group_obj.min_credits' :readonly='!editing'/>
          </div>
          <div v-if='(group_obj && group_obj.min_subjects) || editing'>
          Matérias: {{donesubjects ? donesubjects : '-'}} / 
            <input type='number' class='editable-text min' ref='group_min_subjects' @focus='min_sub_focus = true' @blur='min_sub_focus = false'
                @dblclick='enable_editing' v-if='group_obj' v-model.number='group_obj.min_subjects' :readonly='!editing'/>
          </div>
          <transition name='toolbar-actions'>
            <div v-if='!footer && (!parentobj || parentobj.can_modify)'>
              <div v-if='editing'>
                <check-icon rootClass='header-icon' w='25' h='25' />
              </div>
              <div v-else style='display: flex'>
                <div v-if='!is_group' v-on:click="request_subject_info(group_obj.id)">
                  <information-circle-icon title='Informações' rootClass='header-icon' w='25' h='25' />
                </div>
                <div v-if='!isroot' v-on:click="delete_group">
                  <trash-icon title='Deletar' rootClass='header-icon' w='25' h='25' />
                </div>
                <div v-on:click="enable_editing" v-if='is_group'>
                  <create-icon title='Editar' rootClass='header-icon' w='25' h='25' />
                </div>
                <div v-on:click="add_child" v-if='is_group'>
                  <add-icon title='Adicionar grupo' rootClass='header-icon' w='25' h='25' />
                </div>
              </div>
            </div>
          </transition>
        </div>
      </div>
      <input type="submit" hidden />
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
import InformationCircleIcon from 'vue-ionicons/dist/md-information-circle.vue';

import { Chrome } from 'vue-color';

export default {
  name: 'group-header',
  props: {
    groupobj: { default: null },
    parentobj: { default: null },
    isroot: { default: true },
    footer: { default: false },
    donecredits: { default: null },
    donesubjects: { default: null }
  },
  data() {
    return {
      is_editing: false,
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
    TrashIcon,
    InformationCircleIcon
  },
  computed: {
    group_obj() {
      if (this.footer)
        return {
          name: `Este grupo está vazio!${
            this.parentobj && this.parentobj.can_modify
              ? ' Arraste disciplinas para começar!'
              : ''
          }`
        };
      return this.groupobj;
    },
    // Is it a group?
    is_group() {
      return this.group_obj.type == 'group';
    },
    // Is it a subject index?
    is_index() {
      return this.group_obj.type == 'subject';
    }
  },
  mounted() {
    if (this.group_obj && this.group_obj.new) this.enable_editing();
  },
  methods: {
    request_subject_info(subject_id) {
      window.bus.$emit('request-subject-info', { subject_id });
    },
    async delete_group() {
      try {
        if (this.is_group)
          await auth.request('group/destroy', { group_id: this.group_obj.id });
        else if (this.is_index)
          await auth.request('group/destroy_index', {
            index_id: this.group_obj.id
          });
      } catch (ignore) {}

      this.$emit('update-indices');

      this.parentobj.children.splice(
        this.parentobj.children.findIndex(
          element => element.id === this.group_obj.id
        ),
        1
      );
    },
    delay_save() {
      this.$nextTick(() => {
        if (!this.min_cred_focus && !this.min_sub_focus && !this.title_focus)
          this.changed_group();
      });
    },
    // Change group
    changed_group(evn) {
      let max_val = 999;
      if (this.group_obj.min_credits > max_val)
        this.group_obj.min_credits = max_val;
      if (this.group_obj.min_subjects > max_val)
        this.group_obj.min_subjects = max_val;
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
          .catch(error => console.error(error));
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
        if (!this.min_cred_focus && !this.min_sub_focus && !this.title_focus)
          this.$refs.group_title.focus();
      }
    },
    // Disable editing
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
#header {
}

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
  flex-grow: 1;
  font-family: inherit;
  font-size: medium;
  padding-left: 10px;
}
.left.toolbar {
  flex-grow: 1;
}

.editable-text.min {
  width: 30pt;
}

.editable-text:read-only {
  border: none;
  background-color: #0000;
  color: #000;
  cursor: default;
}
</style>

