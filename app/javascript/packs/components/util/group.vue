<template>
  <div id='root' ref='root'>
    <!-- Draw header -->
    <group-header :groupobj='group_obj' :parentobj='parent_obj' v-on:add-child='add_child'/>
    <!-- Draw children -->
    <div v-if='group_obj && is_group' class='children-list'>
      <draggable v-model="group_obj.children" :options='draggable_options' ghostClass='draggable-ghost' :move='drag_check' :disabled='!group_obj.can_modify'>
        <group :groupobj='child' :parentobj='group_obj' v-for='(child, index) in group_obj.children' v-bind:key="index" />
      </draggable>
    </div>
  </div>
</template>

<script>
import group from './group';
import auth from './auth';

import GroupHeader from './group/group_header';

import draggable from 'vuedraggable';

import { Chrome } from 'vue-color';

export default {
  name: 'group',
  props: {
    groupid: { default: null },
    groupobj: { default: null },
    parentobj: { default: null }
  },
  data() {
    return {
      // Local instance of group objects
      groupo: null,
      pgroupo: null,
      // Options for Vue.Draggable
      draggable_options: {
        animation: 200,
        group: 'item',
        handle: '.handle',
        ghostClass: 'ghost'
      }
    };
  },
  components: {
    'chrome-color-picker': Chrome,
    group,
    GroupHeader,
    draggable
  },
  computed: {
    // Returns this group's id
    group_id() {
      return this.groupid;
    },
    // Return this group's object
    group_obj: {
      get() {
        if (this.groupo) return this.groupo;
        else return this.groupobj;
      },
      set(value) {
        this.groupo = value;
      }
    },
    // Return this group's parent object
    parent_obj: {
      get() {
        if (this.pgroupo) return this.pgroupo;
        else return this.parentobj;
      },
      set(value) {
        this.pgroupo = value;
      }
    },
    // Is it a group?
    is_group() {
      return this.group_obj.type == 'group';
    }
  },
  watch: {
    // Update group on group id changes
    group_id() {
      if (this.group_id != null) this.update();
      else this.group_obj = null;
    }
  },
  beforeMount() {
    // Fetch data from server if not given group from caller
    if (!this.groupo && this.group_id) this.update();
  },
  methods: {
    // Checks if can drag
    drag_check(evn, origEvt) {
      return evn.relatedContext.element.can_modify;
    },
    // Fetch gorup data from server
    update() {
      auth
        .request('group/fetch', { group_id: this.group_id })
        .then(response => {
          this.group_obj = response.data.group;
          console.log(this.group_obj);
        })
        .catch(error => {});
    },
    // Adds child to this group
    add_child() {
      this.group_obj.children.push({
        editing: true,
        type: 'subject',
        code: 'MSH12345',
        name: 'Matéria daora'
      });
    }
  }
};
</script>

<style lang="scss" scoped>
.header-icon {
  color: #555;
  height: 20pt;
  cursor: pointer;
}

.header-icon:hover {
  color: #111;
}

#root {
  border: solid 1px black;
  border-radius: 5px;
  padding: 10pt;
  margin: 10pt;
}

.children-list {
  display: flex;
  flex-direction: column;
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
.editable-text {
}

.editable-text:disabled {
  border: none;
  background-color: #0000;
  color: #000;
}
</style>

