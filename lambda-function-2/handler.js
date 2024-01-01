
'use strict';

module.exports.checkEvenOdd = async (event) => {
  try {
    const requestBody = JSON.parse(event.body);
    console.log('Parsed requestBody:', requestBody);

    const number = requestBody.number;

    let resultMessage;
    if (number % 2 === 0) {
      resultMessage = 'Number is even';
    } else {
      resultMessage = 'Number is odd';
    }

    const result = {
      number: number,
      isEven: number % 2 === 0,
      message: resultMessage,
    };
    console.log('Result:', result);

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: 'Number checked successfully',
        result: result,
      }),
    };
  } catch (error) {
    console.error('Error parsing JSON:', error);
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'Error parsing JSON',
      }),
    };
  }
};
