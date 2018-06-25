<template>
  <div id='root'>
    <div id='header'>
      <!-- If Subject -->
      <div v-if='group_obj && !is_group' class='toolbar'>
        <div id='left'>
          <div>{{group_obj.name}}</div>
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
          <div>
            <create-icon rootClass='toolbar-icon' w='25' h='25' />
          </div>
          <div>
            <add-icon rootClass='toolbar-icon' w='25' h='25' />
          </div>
        </div>
      </div>
      <hr v-if='group_obj && is_group'>
    </div>
    <div v-if='group_obj'>
      <div v-for='(child, index) in group_obj.children' v-bind:key="index">
        <group :groupobj='child'/>
      </div>
    </div>
  </div>
</template>

<script>
import group from './group';
import auth from './auth';

import AddIcon from 'vue-ionicons/dist/md-add.vue';
import CreateIcon from 'vue-ionicons/dist/md-create.vue';
import { Chrome } from 'vue-color';

export default {
  name: 'group',
  props: { groupid: { default: null }, groupobj: { default: null } },
  data() {
    return { groupo: null };
  },
  components: { 'chrome-color-picker': Chrome, group, AddIcon, CreateIcon },
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
    }
  }
};
</script>

<style lang="scss" scoped>
.toolbar-icon {
  color: #555;
  height: 20pt;
  cursor: pointer;
}

.toolbar-icon:hover {
  color: #111;
}

#root {
  border: solid 1px black;
  border-radius: 15pt;
  padding: 15pt;
  margin: 15pt;
}
</style>

