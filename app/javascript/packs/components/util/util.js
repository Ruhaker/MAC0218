export default {
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
