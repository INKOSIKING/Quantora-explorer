import React from "react";
import ValidatorSet from "../modules/validator/ValidatorSet";
import SlashingEvents from "../modules/validator/SlashingEvents";

export default function Validators() {
  return (
    <div>
      <ValidatorSet />
      <SlashingEvents />
    </div>
  );
}