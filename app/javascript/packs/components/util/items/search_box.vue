<template>
  <div id='root'>
    <form>
      <input type='text' placeholder="Procurar" />
    </form>
  </div>
</template>

<script>
export default { name: 'search-box' };
</script>

<style lang="scss" scoped>
/********************
 * Formulary inputs *
 ********************/

$input-field-padding: 5pt;
$input-field-margin: 10pt;
$input-field-border-radius: 8pt;
// Text input styling
form {
  display: flex;
}

form input {
  flex: 1;
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
