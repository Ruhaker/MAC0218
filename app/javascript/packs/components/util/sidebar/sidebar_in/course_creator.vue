<template>
  <div id='root'>
    <div v-on:click='open = !open' id='header'>
      <div class='title'>Criar um novo curso</div>
    </div>
    <transition>
      <div v-if='open' id='form_area'>
        <form v-on:submit.prevent='create'>
            <input type='text' placeholder='Nome' class='editable-text' v-model='name'/>
            <input type='number' placeholder='Créditos' class='editable-text' ref='group_title' v-model='credits'/>
            <select v-model="teaching_unit">
              <option :value='null'>Unidade</option>
              <option value="IME">Instituto de Matemática e Estatística</option>
            </select>
            <input type='number' placeholder='Semestres ideais' class='editable-text' ref='group_title' v-model='expected_time'/>
            <input type="submit" text='test' value='Criar'/>
        </form>
      </div>
    </transition>
    <!--<custom-selector v-if='has_any_courses' selectClass='course-custom-selector' />-->
  </div>
</template>

<script>
import auth from '../../auth.js';

export default {
  name: 'course-chooser',
  data() {
    return {
      open: false,
      name: null,
      credits: null,
      teaching_unit: null,
      expected_time: null
    };
  },
  computed: {},
  beforeMount() {},
  methods: {
    create() {
      auth
        .request('course/create', {
          name: this.name,
          credits: this.credits,
          teaching_unit: this.teaching_unit,
          expected_time: this.expected_time
        })
        .then(result => {
          this.open = false;
        })
        .catch(error => console.error(error));
    }
  }
};
</script>

<style lang="scss" scoped>
// Course selection list
#root {
  display: flex;
  flex-direction: column;
  background-color: #333;
  color: #ddd;
  font-size: 12pt;
  width: 100%;
  text-align: center;
  border-top: solid 1pt #ddd;
  border-bottom: solid 1pt #ddd;

  height: fit-content;

  cursor: pointer;

  transition-duration: 1s;
}

#root > #header:hover {
  background-color: #222;
}

/*************
 * Formulary *
 *************/
form {
  grid-area: form;
  display: flex;
  flex-direction: column;
}

#form_area {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr;
  grid-template-areas: '. . form form form form form .. ';
  vertical-align: middle;
  width: 100%;
  margin-top: 10pt;
  margin-bottom: 10pt;
}

/********************
 * Formulary inputs *
 ********************/

$input-field-padding: 5pt;
$input-field-margin: 5pt;
$input-field-border-radius: 8pt;
// Text input styling
form {
  display: flex;
  flex-direction: column;
}

form input {
  padding: $input-field-padding;
  margin: $input-field-margin;
  border-radius: $input-field-border-radius;
  border: none;
}

.title {
  text-align: start;
  margin: 10pt;
  width: 100%;
}

#course-selector:hover {
  background-color: #292929;
}

.course-custom-selector {
  background-color: red;
  border: none;
  cursor: pointer;
}

// Select input styling
form select {
  padding: $input-field-padding;
  margin: $input-field-margin;
  border-radius: $input-field-border-radius;
  border: none;
}

form select .select-items {
  border-top-left-radius: 5pt;
  border-top-right-radius: 5pt;
}

// Remove arrows from number input
input[type='number']::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
</style>
