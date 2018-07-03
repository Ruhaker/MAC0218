export default {
  progress_texts: ['Não feito', 'Fazendo', 'Feito'],
  progress_color: ['gray', 'yellow', 'green'],
  // Gets copy of the object with specified keys
  pick(obj, keys) {
    return Object.keys(obj)
      .filter(i => keys.includes(i))
      .reduce((acc, key) => {
        acc[key] = obj[key];
        return acc;
      }, {});
  }
};
