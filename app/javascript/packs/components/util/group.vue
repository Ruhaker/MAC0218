<template>
  <div id='root'>
    <div id='header'>
      <!-- If Subject -->
      <div v-if='group_obj && !is_group' class='toolbar'>
        <div id='left'>
          <div>{{group_obj.code}} - {{group_obj.name}}</div>
        </div>
        <div class='spacer'/>
        <div id='right' class='toolbar'>
        </div>
      </div>
      <!-- If Group -->
      <div v-if='group_obj && is_group' class='toolbar'>
        <div id='left'>
          <div>{{group_obj.name}}</div>
        </div>
        <div class='spacer'/>
        <div id='right' class='toolbar'>
          <div v-if='true' style='display: flex'>
            <div v-on:click="enable_editing">
              <create-icon rootClass='header-icon' w='25' h='25' />
            </div>
            <div v-on:click="add_child">
              <add-icon rootClass='header-icon' w='25' h='25' />
            </div>
          </div>
        </div>
      </div>
      <hr v-if='group_obj && is_group'>
    </div>
    <!-- Draw children -->
    <div v-if='group_obj'>
      <transition-group name='children-list'>
        <div v-for='(child, index) in group_obj.children' v-bind:key="index" class='children-list-item'>
          <group :groupobj='child'/>
        </div>
      </transition-group>
    </div>
  </div>
</template>

<script>
import group from './group';
import auth from './auth';

import AddIcon from 'vue-ionicons/dist/md-add.vue';
import CreateIcon from 'vue-ionicons/dist/md-create.vue';
import CheckIcon from 'vue-ionicons/dist/md-checkmark.vue';

import { Chrome } from 'vue-color';

export default {
  name: 'group',
  props: { groupid: { default: null }, groupobj: { default: null } },
  data() {
    return { groupo: null };
  },
  components: {
    'chrome-color-picker': Chrome,
    group,
    AddIcon,
    CreateIcon,
    CheckIcon
  },
  computed: {
    group_id() {
      return this.groupid;
    },
    group_obj: {
      get() {
        if (this.groupobj) return this.groupobj;
        else return this.groupo;
      },
      set(value) {
        this.groupo = value;
      }
    },
    is_group() {
      return this.group_obj.type == 'group';
    }
  },
  watch: {
    group_id() {
      if (this.group_id != null) this.update();
      else this.group_obj = null;
    }
  },
  beforeMount() {
    if (!this.groupo && this.group_id) this.update();
  },
  methods: {
    update() {
      auth
        .request('group/fetch', { group_id: this.group_id })
        .then(response => {
          this.group_obj = response.data.group;
        })
        .catch(error => {});
    },
    enable_editing() {},
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
  border-radius: 15pt;
  padding: 15pt;
  margin: 15pt;
}

// List transitions
.children-list-item {
  transition: all 0.25s;
  margin-right: 10px;
}

.children-list-enter,
.children-list-leave-to {
  opacity: 0;
  transform: translateY(15px);
}

.children-list-leave-active {
  position: absolute;
}
</style>

