'use strict';

module.exports.generateRandomNumber = async (event) => {
  const randomNumber = Math.floor(Math.random() * 100) + 1;

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: 'Random number generated successfully',
      number: randomNumber,
    }),
  };
};
