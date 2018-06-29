<template>
  <div id='root' ref='root'>
    <!-- Draw header -->
    <group-header :groupobj='group_obj' :parentobj='parent_obj' :isroot='is_root' v-on:add-child='add_child' v-on:reload-group='update'/>
    <!-- Draw children -->
    <div v-if='group_obj && is_group' class='children-list'>
      <draggable v-model="group_obj.children" v-on:change='changed_children'
          :options='draggable_options' ghostClass='draggable-ghost' :move='drag_check' :disabled='!group_obj.can_modify'>
        <group :groupobj='child' :parentobj='group_obj' v-for='child in group_obj.children' v-bind:key="child.id" />
        <div>
          <group-footer v-if='group_obj.children.length == 0' />
        </div>
      </draggable>
    </div>
  </div>
</template>

<script>
import group from './group';
import auth from './auth';

import regeneratorRuntime from 'regenerator-runtime';

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
      if (this.groupid) return this.groupid;
      if (!this.group_obj) return null;
      return this.group_obj.id;
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
    },
    // Is it a root group?
    is_root() {
      return this.parent_obj == null;
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

    // If requested reload, update data
    window.bus.$on('reload-groups', () => this.update());
  },
  methods: {
    async changed_children(evn) {
      if (evn.added) {
        try {
          await auth.request('group/update', {
            group_id: evn.added.element.id,
            parent_id: this.group_id
          });
        } catch (e) {
          return;
        }
      }
      this.update_indices();
    },

    update_indices() {
      var error = false;
      this.group_obj.children.forEach((child, index) => {
        auth
          .request('group/update', {
            type: child.type,
            group_id: child.id,
            index
          })
          .then(() => {
            child.index = index;
          })
          .catch(e => (error = true));
      });
      if (error) this.update();
    },
    // Checks if can drag
    drag_check(evn, origEvt) {
      return (
        evn.relatedContext.element && evn.relatedContext.element.can_modify
      );
    },
    // Fetch group data from server
    update(data) {
      var group_id = this.group_id;
      if (data) group_id = data.group_id;
      auth
        .request('group/fetch', { group_id: group_id })
        .then(response => {
          console.log(response.data.group);
          this.group_obj = response.data.group;
        })
        .catch(error => {});
    },
    // Adds child to this group
    add_child(data) {
      data.new_index = this.group_obj.children.length;
      this.group_obj.children.push(data);
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

// Editable text fields
.editable-text {
}

.editable-text:disabled {
  border: none;
  background-color: #0000;
  color: #000;
}
</style>

