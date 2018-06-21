<template>
  <div id='root'>
    <div id='form_area'>
      <form v-on:submit.prevent="login">
          <input type='email' placeholder="email" v-model="form_email"/>
          <input :type='visible_pass ? "text" : "password"' placeholder="password" v-model="form_password"/>
          <transition name='fade-shrink' class='form-section'>
            <div v-if="!sign_in_mode">
              <div style="display: flex; flex-direction: column;">
                <input :type='visible_pass ? "text" : "password"' placeholder="confirm password" v-model="form_cpassword" />
                <select v-model="form_user_type" >
                  <option value='student'>{{text.user_type.student}}</option>
                  <option value='supervisor'>{{text.user_type.supervisor}}</option>
                </select>
                <input type='number' :placeholder="form_user_type == 'student' ? 'nusp' : 'cpf'" v-model="form_identifier" />
              </div>
            </div>
          </transition>
          <div class='link' v-on:click="() => sign_in_mode = !sign_in_mode">
            {{sign_in_mode ? "Não tem uma conta? Clique aqui para criar!" : "Já tem uma conta? Clique aqui para entrar!"}}
          </div>
          <input type='submit'/>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'sidebar-out',
  props: {},
  data() {
    return {
      // Strings
      text: {
        user_type: {
          student: 'Estudante',
          supervisor: 'Supervisor'
        }
      },
      // Toggles
      visible_pass: false,
      sign_in_mode: true,
      // Form data
      form_user_type: 'student',
      form_email: '',
      form_password: '',
      form_cpassword: '',
      form_identifier: ''
    };
  },
  methods: {
    login: () => {
      alert('HEllo');
    }
  }
};
</script>

<style lang='scss' scoped>
#root {
  height: 100%;
  align-items: center;
  color: #ddd;
}

.link {
  margin-top: 5pt;
  font-size: 10pt;
  cursor: pointer;
  text-align: center;
}

.link:hover {
  color: #ccc;
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

// Select input styling
form select {
  padding: $input-field-padding;
  margin: $input-field-margin;
  border-radius: $input-field-border-radius;
  border: none;
}

// Remove arrows from number input
input[type='number']::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

// Removes blue outline
form input:focus {
  outline: none;
}

form select:focus {
  outline: none;
}

// Animation
$section-height: 150px;
$anim-time: 0.15s;

.fade-shrink-enter-active {
  max-height: $section-height;
  transition: max-height $anim-time, opacity $anim-time $anim-time;
}

.fade-shrink-leave-active {
  max-height: $section-height;
  transition: opacity $anim-time, max-height $anim-time $anim-time;
}

.fade-shrink-enter,
.fade-shrink-leave-to {
  opacity: 0;
  max-height: 0;
}

@keyframes fade-shrink-in {
  0% {
    max-height: 0;
  }
  50% {
    opacity: 1;
    max-height: scale(1);
  }
  100% {
    opacity: 1;
  }
}

/********************
 * Formulary button *
 ********************/
input[type='submit'] {
  margin: 10pt 20pt 10pt 20pt;
  height: 20pt;
  border: none;
}

input[type='submit']:hover {
  background-color: #bbb;
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
}
</style>