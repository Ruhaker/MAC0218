<template>
    <div class='root' ref='root' :footer='footer' v-if='group_obj || footer'>
      <!-- Draw header -->
      <div class='header'>
        <group-header :groupobj='group_obj' :parentobj='parent_obj' :isroot='is_root'
            :donecredits='done_credits' :donesubjects='done_subjects' v-on:add-child='add_child' v-on:reload-group='update' :footer='footer'/>
        <div v-if='group_obj && !is_group' class='status-band'/>
      </div>
      <!-- Draw children -->
      <div v-if='!footer && group_obj && is_group' class='children-list'>
        <draggable v-model="group_obj.children" v-on:change='changed_children'
            :options='draggable_options' ghostClass='draggable-ghost' :move='drag_check' :disabled='!group_obj.can_modify'>
          <group :groupobj='child' :parentobj='group_obj' v-for='child in group_obj.children' v-bind:key="child.id" />
          <group :parentobj='group_obj' v-if='group_obj.children && group_obj.children.length == 0' :footer='true'/>
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
    parentobj: { default: null },
    footer: { default: false }
  },
  data() {
    return {
      // Local instance of group objects
      groupo: null,
      pgroupo: null,
      done_credits: null,
      done_subjects: null,
      // Options for Vue.Draggable
      draggable_options: {
        animation: 200,
        group: 'item',
        handle: '.handle'
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
    // Return this group's type
    group_type() {
      if (!this.group_obj) return null;
      return this.group_obj.type;
    },
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
  mounted() {
    this.update_progress();
  },
  methods: {
    async update_progress() {
      await this.update();
      this.calc_progress().then(res => {
        if (this.group_obj) {
          this.group_obj.done_credits = res.credits;
          this.group_obj.done_subjects = res.subjects;
        }
      });
    },
    async calc_progress(group, res) {
      let user = await auth.get_user_object();
      if (!user || user.type != 'student')
        return { credits: null, subjects: null };
      if (!group) group = this.group_obj;
      if (!res) res = { credits: 0, subjects: 0 };

      if (group.type == 'group') {
        if (group.done_credits && group.done_subjects) {
          res.credits += group.done_credits;
          red.subjects += group.done_subjects;
        } else
          group.children.forEach(child => {
            this.calc_progress(child, res);
          });
      } else if (group.type == 'subject') {
        if (group.progress == 2) {
          res.credits += group.credits;
          res.subjects++;
        }
      }

      return res;
    },
    async changed_children(evn) {
      if (evn.added) {
        console.log(evn);
        if (evn.added.element.type == 'group') {
          try {
            await auth.request('group/update', {
              group_id: evn.added.element.id,
              parent_id: this.group_id
            });
          } catch (e) {
            console.log(e);
            return;
          }
        } else if (evn.added.element.type == 'new_subject') {
          try {
            await auth.request('group/add_subject', {
              group_id: this.group_id,
              subject_id: evn.added.element.id,
              ordering: evn.added.newIndex
            });
          } catch (e) {
            console.log(e);
            return;
          }
        } else if (evn.added.element.type == 'subject') {
          try {
            await auth.request('group/update_index', {
              index_id: evn.added.element.id,
              group_id: this.group_id
            });
          } catch (e) {
            console.log(e);
            return;
          }
        }
      }
      this.update_indices();
    },

    update_indices() {
      var error = false;
      this.group_obj.children.forEach((child, index) => {
        if (child.type == 'group')
          auth
            .request('group/update', {
              group_id: child.id,
              index
            })
            .then(() => {
              child.index = index;
            })
            .catch(e => (error = true));
        else if (child.type == 'subject')
          auth
            .request('group/update_index', { index_id: child.id, index })
            .then(() => {
              child.index = index;
            });
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
    async update(data) {
      var group_id = this.group_id;
      if (data) group_id = data.group_id;
      if (this.groupid || this.group_type == 'group') {
        let response = await auth.request('group/fetch', {
          group_id: group_id
        });
        console.log(response.data.group);
        this.group_obj = response.data.group;
      }
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

.root {
  border: solid 0.7px #00000029;
  border-radius: 40px;
  padding: 10pt;
  margin: 10pt;
  box-shadow: 0.4px 0.7px #3333337a;
  background-color: white;
}

.root[footer='true'] {
  border: dashed 1px black;
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
.editable-text:disabled {
  border: none;
  background-color: #0000;
  color: #000;
}

.group #root {
  background-color: greenyellow;
}
</style>

