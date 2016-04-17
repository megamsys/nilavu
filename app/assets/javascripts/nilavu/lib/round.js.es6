import decimalAdjust from "nilavu/lib/decimal-adjust";

export default function(value, exp) {
  return decimalAdjust("round", value, exp);
}
